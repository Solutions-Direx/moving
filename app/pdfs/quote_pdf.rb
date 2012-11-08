# encoding: utf-8
class QuotePdf < Prawn::Document
  include ActionView::Helpers::NumberHelper
  include ActionView::Helpers::TextHelper

  PAGE_WIDTH = 572

  def initialize(quote, to_addresses)
    super(top_margin: 20, left_margin: 20, right_margin: 20, bottom_margin: 20, page_layout: :portrait)
    @quote = quote
    @to_addresses = to_addresses

    page_layout

    number_pages "Page <page> of <total>", { :start_count_at => 1, :at => [bounds.right - 200, 5], :align => :right, :size => 8, color: 'AAAAAA' }
  end

  def page_layout
    quote_header
    move_down 20
    text "<b>#{I18n.t('removal_at')}:</b> " + I18n.l(@quote.removal_at, :format => :long) + (@quote.pm? ? "(PM) #{I18n.t('removal_time_confirmation')}" : "") + " || " + (@quote.is_house? ? "#{I18n.t('house')}" : "#{I18n.t('apartment')}"), inline_format: true
    move_down 5    
    if @quote.contact.present?
      text "<b>#{Quote.human_attribute_name("contact")}:</b> " + @quote.contact, inline_format: true
      move_down 5
    end

    if @quote.comment.present?
      table([[@quote.comment]], width: PAGE_WIDTH) do
        cells.borders = []
        row(0).column(0).padding = [10, 10, 10, 10]
        cells.style(background_color: "f5f5f5", border_color: "CCCCCC")
      end  
      move_down 15
      addresses
      move_down 10
      rooms
      move_down 10
      furniture
    end
  end

  def hr
    move_down 10
    stroke_color "CCCCCC"
    stroke_horizontal_rule
  end

  def furniture
    if @quote.furniture
      text I18n.t('nb_appliances') + ": #{@quote.furniture.try(:num_appliances)}"
      move_down 10
      text I18n.t('nb_boxes') + ": #{@quote.furniture.try(:num_boxes)}"
      move_down 10

      kitchen_data = [["<b><font size='13'>#{I18n.t('kitchen')}</font></b>"]]
      kitchen_data << [pluralize(@quote.furniture.kitchen_table, 'Table')] if @quote.furniture.kitchen_table.present?
      kitchen_data << [pluralize(@quote.furniture.kitchen_chair, "#{I18n.t('chair')}")] if @quote.furniture.kitchen_chair.present?
      kitchen_data << [pluralize(@quote.furniture.kitchen_buffet, 'Buffet')] if @quote.furniture.kitchen_buffet.present?

      kitchen_table = make_table(kitchen_data, width: 275) do
        cells.inline_format = true
        cells.padding = [10, 10, 0, 10]
        cells.size = 11
        cells.borders = []
        cells.style(background_color: "f5f5f5", border_color: "CCCCCC")
        row(kitchen_data.size - 1).padding = [10, 10, 10, 10]
      end

      living_room_data = [["<b><font size='13'>#{I18n.t('living_room')}</font></b>"]]
      living_room_data << [pluralize(@quote.furniture.living_couch_3pl, "#{I18n.t('sofa')}") + ' 3pl'] if @quote.furniture.living_couch_3pl.present?
      living_room_data << [pluralize(@quote.furniture.living_couch_2pl, "#{I18n.t('sofa')}") + ' 2pl'] if @quote.furniture.living_couch_2pl.present?
      living_room_data << [pluralize(@quote.furniture.living_table, 'Table')] if @quote.furniture.living_table.present?
      living_room_data << [pluralize(@quote.furniture.living_armchair, "#{I18n.t('armchair')}")] if @quote.furniture.living_armchair.present?
      living_room_data << [pluralize(@quote.furniture.living_wall_unit, "#{I18n.t('wall_unit')}")] if @quote.furniture.living_wall_unit.present?
      living_room_data << [pluralize(@quote.furniture.living_tv, 'TV')] if @quote.furniture.living_tv.present?

      living_room_table = make_table(living_room_data, width: 275) do
        cells.inline_format = true
        cells.padding = [10, 10, 0, 10]
        cells.size = 11
        cells.borders = []
        cells.style(background_color: "f5f5f5", border_color: "CCCCCC")
        row(living_room_data.size - 1).padding = [10, 10, 10, 10]
      end

      table([[kitchen_table, living_room_table]]) do
        cells.borders = []
        row(0).column(0).padding = [0, 22, 0, 0]
      end
    end
  end

  def rooms
    @quote.rooms.each_with_index do |room, index|
      hr
      move_down 15
      text I18n.t('room') + " ##{index + 1}: " + I18n.t(room.size) + " " + room.comment
    end
  end

  def addresses
    kitchen_data = [["<b><font size='13'>#{@quote.internal_address? ? I18n.t('internal_moving') : I18n.t('from')}</font></b>"]]

    if @quote.from_address.has_storage?
      kitchen_data << ["<font size='10'><color rgb='999999'>#{I18n.t('storage_upcase')}:</color> #{@quote.from_address.storage.name}</font>"]
      kitchen_data << [address_for(@quote.from_address.storage.address)]
    else
      kitchen_data << ["<color rgb='999999'><font size='10'>#{I18n.t('address').upcase}</font></color>"]
      kitchen_data << [address_for(@quote.from_address.address)]
    end

    from_table = make_table(kitchen_data, width: 275) do
      cells.inline_format = true
      cells.padding = [10, 10, 10, 10]
      cells.size = 11
      cells.style(background_color: "f5f5f5", border_color: "CCCCCC")

      row(0).style(borders: [:top, :left, :right], padding: [10, 10, 0, 10])
      row(1).style(borders: [:left, :right], padding: [10, 10, 0, 10])
      row(2).style(borders: [:bottom, :left, :right])
    end

    unless @quote.internal_address?
      to_data = [["<b><font size='13'>#{I18n.t('to')}</font></b>"]]
      unless @quote.to_addresses.blank?
        for to_address in @quote.to_addresses
          if to_address.has_storage?
            internal = to_address.storage_id && to_address.storage.internal? ? I18n.t('internal') : ''
            to_data << ["<font size='10'><color rgb='999999'>#{I18n.t('storage_upcase')}: #{to_address.storage.name.upcase} #{internal.upcase}</color></font>"]
            to_data << [address_for(to_address.storage.address)]
          else
            to_data << ["<color rgb='999999'><font size='10'>#{I18n.t('address').upcase}</font></color>"]
            to_data << [address_for(to_address.address)]
          end
        end
      end

      to_table = make_table(to_data, width: 275) do
        cells.inline_format = true
        cells.padding = [10, 10, 10, 10]
        cells.size = 11
        cells.style(background_color: "f5f5f5", border_color: "CCCCCC")

        row(0).style(borders: [:top, :left, :right], padding: [10, 10, 0, 10])
        row(1).style(borders: [:left, :right], padding: [10, 10, 0, 10])
        row(2).style(borders: [:bottom, :left, :right])
      end      
    else
      to_table = make_table([[""]], width: 275, :cell_style => {:border_color => "FFFFFF", :borders => []})
    end

    table([[from_table, to_table]]) do
      cells.borders = []
      row(0).column(0).padding = [0, 22, 0, 0]
    end
  end

  def quote_header
    table([[company_address_block, quote_number_block]]) do
      cells.borders = []
      row(0).column(0).padding = [0, 32, 0, 0]
    end  
  end

  def company_address_block
    data = []
    # if @quote.company.logo.present?
    #   logo = Rails.root.join("public", "uploads", "company", @quote.company_id.to_s, "logo", "thumb", @quote.company.logo_file_name).to_s
    #   data << [{:image => logo}]
    # end
    data << [@quote.company.invoice_header]

    make_table(data, width: 270, :cell_style => {:border_color => "FFFFFF"}) do
      # cells.padding = [10, 10, 10, 10]
      rows(0).size = 10
    end
  end

  def quote_number_block
    data = [
      [@quote.client.name_with_code],
      [Quote.model_name.human + " ##{@quote.code}"]
    ]
    make_table(data, width: 270, :cell_style => {:border_color => "FFFFFF"}) do
      cells.padding = [0, 0, 0, 0]
      cells.style(size: 18, font_style: :bold, align: :right)
    end
  end

  def address_for(address)
    optional_address = [address.city, address.province, address.postal_code].select{|s| s.present?}.join(", ")
    address.address + "\n" + optional_address
  end

end