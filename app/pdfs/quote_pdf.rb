# encoding: utf-8
require 'open-uri'
require 'nokogiri'
require 'cgi'

class QuotePdf < Prawn::Document
  include ActionView::Helpers::NumberHelper
  include ActionView::Helpers::TextHelper

  PAGE_WIDTH = 572

  def initialize(quote, to_addresses, full_print)
    super(top_margin: 20, left_margin: 20, right_margin: 20, bottom_margin: 20, page_layout: :portrait)
    @quote = quote
    @to_addresses = to_addresses
    @full_print = full_print

    page_layout

    number_pages "#{Quote.model_name.human} ##{@quote.code} | Page <page> / <total>", { :start_count_at => 1, :at => [bounds.right - 200, 5], :align => :right, :size => 10, color: 'AAAAAA' }
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
    end
    move_down 10
    addresses
    move_down 10
    rooms
    move_down 10
    furniture
    hr
    move_down 10
    quote_details
    documents

    if @full_print
      start_new_page
      invoices
    end

    if @to_addresses.present?
      start_new_page
      google_map
    end
  end

  def hr
    move_down 10
    stroke_color "CCCCCC"
    stroke_horizontal_rule
  end

  def quote_details
    removal_leader = @quote.removal_leader.present? ? "- #{@quote.removal_leader.full_name}" : ""
    removal_men = @quote.removal_men.any? ? ", #{@quote.removal_men.map(&:full_name).to_sentence}" : ""
    text "<b>#{I18n.t('removal_men', default: 'Removal men')}</b>: #{@quote.num_of_removal_man} #{removal_leader}#{removal_men}", inline_format: true
    move_down 10
    text "<b>#{I18n.t('price')}</b>: #{number_to_currency(@quote.price, strip_insignificant_zeros: true)} #{I18n.t('per_hour')}", inline_format: true
    move_down 10
    text "<b>#{I18n.t('gas')}</b>: #{number_to_currency(@quote.gas, strip_insignificant_zeros: true)}", inline_format: true
    move_down 10
    if @quote.surcharges.any?
      @quote.surcharges.each do |surcharge|
        text "<b>#{surcharge.label}</b>: #{number_to_currency(surcharge.price, strip_insignificant_zeros: true)}", inline_format: true
        move_down 10
      end
    end

    long_distance = @quote.long_distance ? "(#{I18n.t('long_distance')})" : ""
    text "<b>#{I18n.t('transport_time', default: 'Transport time')}</b>: #{@quote.transport_time} #{long_distance}", inline_format: true
    move_down 10
    
    if @quote.from_address.has_storage?
      group do
        text "<b>#{Storage.model_name.human}</b>", inline_format: true
        move_down 10
        text "<font size='10'><color rgb='999999'>#{@quote.from_address.storage.name.upcase}</color></font>"
        move_down 10
        if @quote.from_address.insurance.present?
          storage_insurance = "+ " + I18n.t('insurance') + ": " + number_to_currency(@quote.from_address.insurance, strip_insignificant_zeros: true)
        end
        text "<b>#{I18n.t('price_per_month')}</b>: #{number_to_currency(@quote.from_address.price, strip_insignificant_zeros: true)} #{storage_insurance}", inline_format: true
      end
      move_down 10
    end

    unless @quote.to_addresses.blank?
      group do
        for to_address in @quote.to_addresses
          if to_address.has_storage?
            text "<font size='10'><color rgb='999999'>#{to_address.storage.name.upcase}</color></font>", inline_format: true
            move_down 10
            if to_address.insurance.present?
              storage_insurance = "+ " + I18n.t('insurance') + ": " + number_to_currency(to_address.insurance, strip_insignificant_zeros: true)
            end
            text "<b>#{I18n.t('price_per_month')}:</b> #{number_to_currency(to_address.price, strip_insignificant_zeros: true)} #{storage_insurance}", inline_format: true
            move_down 10
          end
        end
      end
    end

    insurance = @quote.insurance? ? "#{I18n.t('included')}" : "#{I18n.t('not_included')}"
    text "<b>#{I18n.t('insurance')}</b>: #{insurance}", inline_format: true
    move_down 10

    equipment = @quote.materiel? ? "#{I18n.t('included')}" : "#{I18n.t('not_included')}"
    text "<b>#{I18n.t('equipment', default: 'Equipment')}</b>: #{equipment}", inline_format: true
    move_down 10

    if @quote.deposit.present?
      card_type = @quote.deposit.credit_card_type.present? ? "(#{I18n.t(@quote.deposit.credit_card_type)})" : ""
      text "<b>#{I18n.t('deposit_received')}</b>: #{number_to_currency(@quote.deposit.amount, strip_insignificant_zeros: true)} - #{I18n.l(@quote.deposit.date, format: :long)} - #{I18n.t(@quote.deposit.payment_method)} #{card_type}", inline_format: true      
      move_down 10
    end

    if @quote.trucks.any?
      group do
        text "<b>#{Truck.model_name.human + 's'}</b>", inline_format: true
        move_down 10
        @quote.trucks.each do |truck|
          text "•  #{truck.name_with_plate}" , leading: 3, size: 11, indent_paragraphs: 10
          move_down 10
        end
      end
    end

    if @quote.quote_supplies.any?
      group do
        text "<b>#{Supply.model_name.human + 's'}</b>", inline_format: true
        move_down 10
        @quote.quote_supplies.each do |q_supply|
          text "•  #{q_supply.quantity} * #{q_supply.supply.name_with_price}" , leading: 3, size: 11, indent_paragraphs: 10
          move_down 10
        end
      end
    end

    if @quote.forfaits.any?
      group do
        text "<b>Forfaits</b>", inline_format: true
        move_down 10
        @quote.forfaits.each do |forfait|
          text "•  #{forfait.name_with_price}" , leading: 3, size: 11, indent_paragraphs: 10
          move_down 10
        end
      end
    end

    if @quote.confirmed?
      group do
        text "<b>#{I18n.t('quote_confirmation', default: 'Quote confirmation')}</b>", inline_format: true
        move_down 10
        text I18n.t('approved_on') + " " + I18n.l(@quote.quote_confirmation.approved_at, :format => :long) + " #{I18n.t('by')} " + @quote.quote_confirmation.user.full_name
        move_down 10
        text "#{I18n.t('insurance_increase')} : #{@quote.quote_confirmation.insurance_limit_enough? ? I18n.t('nope') : number_to_currency(@quote.quote_confirmation.insurance_increase)}"
        move_down 10
        text I18n.t('franchise_cancelation') + ": " + (@quote.quote_confirmation.franchise_cancellation? ? I18n.t('yessai') + " (#{I18n.t('fees')} #{number_to_currency(@quote.account.franchise_cancellation_amount, strip_insignificant_zeros: true)})" : I18n.t('nope') )
        move_down 10
        text I18n.t('tv_insurance') + ": " + (@quote.quote_confirmation.tv_insurance? ? I18n.t('yessai') + " (#{I18n.t('fees')} #{number_to_currency(@quote.quote_confirmation.tv_insurance_price, strip_insignificant_zeros: true)})" : I18n.t('nope') )
        move_down 10
        unless @quote.client.commercial?
          text I18n.t('payment_method') + ": " + I18n.t(@quote.quote_confirmation.payment_method)
          move_down 10
        end
      end
    end
  end

  def furniture
    if @quote.furniture
      text I18n.t('nb_appliances') + ": #{@quote.furniture.try(:num_appliances)}"
      move_down 10
      text I18n.t('nb_boxes') + ": #{@quote.furniture.try(:num_boxes)}"
      move_down 10

      kitchen_data = [["<b><font size='13'>#{I18n.t('kitchen')}</font></b>"]]
      kitchen_data << ["•  " + pluralize(@quote.furniture.kitchen_table, 'Table')] if @quote.furniture.kitchen_table.present?
      kitchen_data << ["•  " + pluralize(@quote.furniture.kitchen_chair, "#{I18n.t('chair')}")] if @quote.furniture.kitchen_chair.present?
      kitchen_data << ["•  " + pluralize(@quote.furniture.kitchen_buffet, 'Buffet')] if @quote.furniture.kitchen_buffet.present?

      kitchen_table = make_table(kitchen_data, width: 275) do
        cells.inline_format = true
        cells.padding = [5, 5, 0, 5]
        cells.size = 11
        cells.borders = []
        cells.style(background_color: "f5f5f5", border_color: "CCCCCC")
        row(kitchen_data.size - 1).padding = [5, 5, 5, 5]
      end

      living_room_data = [["<b><font size='13'>#{I18n.t('living_room')}</font></b>"]]
      living_room_data << ["•  " + pluralize(@quote.furniture.living_couch_3pl, "#{I18n.t('sofa')}") + ' 3pl'] if @quote.furniture.living_couch_3pl.present?
      living_room_data << ["•  " + pluralize(@quote.furniture.living_couch_2pl, "#{I18n.t('sofa')}") + ' 2pl'] if @quote.furniture.living_couch_2pl.present?
      living_room_data << ["•  " + pluralize(@quote.furniture.living_table, 'Table')] if @quote.furniture.living_table.present?
      living_room_data << ["•  " + pluralize(@quote.furniture.living_armchair, "#{I18n.t('armchair')}")] if @quote.furniture.living_armchair.present?
      living_room_data << ["•  " + pluralize(@quote.furniture.living_wall_unit, "#{I18n.t('wall_unit')}")] if @quote.furniture.living_wall_unit.present?
      living_room_data << ["•  " + pluralize(@quote.furniture.living_tv, 'TV')] if @quote.furniture.living_tv.present?

      living_room_table = make_table(living_room_data, width: 275) do
        cells.inline_format = true
        cells.padding = [5, 5, 0, 5]
        cells.size = 11
        cells.borders = []
        cells.style(background_color: "f5f5f5", border_color: "CCCCCC")
        row(living_room_data.size - 1).padding = [5, 5, 5, 5]
      end

      table([[kitchen_table, living_room_table]]) do
        cells.borders = []
        row(0).column(0).padding = [0, 22, 0, 0]
      end


      basement_data = [["<b><font size='13'>#{I18n.t('basement')}</font></b>"]]
      basement_data << ["•  " + pluralize(@quote.furniture.base_salon, I18n.t('salon_sets', default: 'Salon sets'))] if @quote.furniture.base_salon.present?
      basement_data << ["•  " + pluralize(@quote.furniture.base_shelf, I18n.t('shelf'))] if @quote.furniture.base_shelf.present?
      basement_data << ["•  " + pluralize(@quote.furniture.base_desk, I18n.t('desk', default: 'Desks'))] if @quote.furniture.base_desk.present?
      basement_data << ["•  " + pluralize(@quote.furniture.base_training, I18n.t('training_sets', default: 'Training sets'))] if @quote.furniture.base_training.present?

      basement_table = make_table(basement_data, width: 275) do
        cells.inline_format = true
        cells.padding = [5, 5, 0, 5]
        cells.size = 11
        cells.borders = []
        cells.style(background_color: "f5f5f5", border_color: "CCCCCC")
        row(basement_data.size - 1).padding = [5, 5, 5, 5]
      end

      outside_data = [["<b><font size='13'>#{I18n.t('outside')}</font></b>"]]
      outside_data << ["•  " + pluralize(@quote.furniture.outside_tire, I18n.t('tires', default: 'Tires'))] if @quote.furniture.outside_tire.present?
      outside_data << ["•  " + pluralize(@quote.furniture.outside_lawn_mower, I18n.t('lawn_mower'))] if @quote.furniture.outside_lawn_mower.present?
      outside_data << ["•  " + pluralize(@quote.furniture.outside_bike, I18n.t('bike'))] if @quote.furniture.outside_bike.present?
      outside_data << ["•  " + pluralize(@quote.furniture.outside_table, I18n.t('patio_tables', default: 'Patio tables'))] if @quote.furniture.outside_table.present?
      outside_data << ["•  " + pluralize(@quote.furniture.outside_bbq, 'BBQ')] if @quote.furniture.outside_bbq.present?

      outside_table = make_table(outside_data, width: 275) do
        cells.inline_format = true
        cells.padding = [5, 5, 0, 5]
        cells.size = 11
        cells.borders = []
        cells.style(background_color: "f5f5f5", border_color: "CCCCCC")
        row(outside_data.size - 1).padding = [5, 5, 5, 5]
      end

      move_down 10
      table([[basement_table, outside_table]]) do
        cells.borders = []
        row(0).column(0).padding = [0, 22, 0, 0]
      end

      move_down 10
      if @quote.furniture.furniture_other.present?
        text I18n.t('other') + ": " + @quote.furniture.furniture_other
      end
    end
  end

  def rooms
    @quote.rooms.each_with_index do |room, index|
      hr
      move_down 10
      text I18n.t('room') + " ##{index + 1}: " + I18n.t(room.size) + " " + (room.comment.present? ? room.comment : "")
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
      cells.padding = [5, 5, 5, 5]
      cells.size = 11
      cells.style(background_color: "f5f5f5", border_color: "CCCCCC")
      cells.borders = []

      row(0).style(padding: [5, 5, 0, 5])
      row(1).style(padding: [5, 5, 0, 5])
      # row(2).style(borders: [:bottom, :left, :right])
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
        cells.padding = [5, 5, 5, 5]
        cells.size = 11
        cells.style(background_color: "f5f5f5", border_color: "CCCCCC")
        cells.borders = []

        row(0).style(padding: [5, 5, 0, 5])
        row(1).style(padding: [5, 5, 0, 5])
        # row(2).style()
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
    if @quote.company.logo.present?
      logo = Rails.root.join("public", "uploads", "company", @quote.company_id.to_s, "logo", "thumb", @quote.company.logo_file_name).to_s
      data << [{:image => logo, :scale => 0.6}]
    end
    data << [@quote.company.invoice_header]

    make_table(data, width: 270, :cell_style => {:border_color => "FFFFFF"}) do
      # cells.padding = [10, 10, 10, 10]
      rows(1).size = 8
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

  def google_map
    if @to_addresses && @to_addresses.any?
      @to_addresses.each do |to_address|
        url = URI.escape(QuoteAddress.static_map_link(@quote.from_address, to_address, options={size: '572x300'}))
        image open(url)
        move_down 10
        text "<link href='#{QuoteAddress.static_map_link(@quote.from_address, to_address, options={size: '700x400'})}'>#{I18n.t('get_directions', default: 'Get Directions')}</link>", inline_format: true, :align => :center, color: "#333399" 
      end
    end
  end

  def documents
    if @quote.documents.any?
      hr
      move_down 20
      @quote.documents.each_with_index do |document, index|
        text "<b><font size='14'>#{document.name}</font></b>", inline_format: true
        move_down 10
        s = html_to_text(document.body)
        text s, inline_format: true
        move_down 10
        if index != @quote.documents.size - 1
          stroke_color "CCCCCC"
          stroke_horizontal_rule
          move_down 10
        end
      end
    end
  end

  def invoices
    quote_header
    move_down 15
    text "<b><font size='14'>#{I18n.t('temp_invoice', default: 'Temporary Invoice')}</font></b>", inline_format: true
    move_down 10
    if @quote.price.present?
      text "___ " + I18n.t('billed_hours', default: 'Billed Hours') + " * " + number_to_currency(@quote.price) + " = _________________________"
    else
      text "___ " + I18n.t('billed_hours', default: 'Billed Hours') + " * " + "___________$" + " = _________________________"
    end
    move_down 10
    text "<b>#{I18n.t('gas')}:</b> #{number_to_currency(@quote.gas)}", inline_format: true
    move_down 10

    if @quote.surcharges.any?
      @quote.surcharges.each do |surcharge|
        text "<b>#{surcharge.label}:</b> #{number_to_currency(surcharge.price)}", inline_format: true
        move_down 10
      end
    end

    text "<b>#{I18n.t('supplies')}:</b>", inline_format: true
    move_down 5
    @quote.quote_supplies.each do |q_supply|
      text q_supply.quantity && " * " && q_supply.supply.name_with_price
      move_down 10
    end
    text Supply.model_name.human + ": _________________________"
    move_down 10

    text "<b>#{I18n.t('forfaits', default: 'Forfaits')}:</b>", inline_format: true
    move_down 5
    @quote.forfaits.each do |forfait|
      text "•  #{forfait.name_with_price}" , leading: 3, size: 11, indent_paragraphs: 10
      move_down 10
    end
    text Forfait.model_name.human + ": _________________________"
    move_down 10
    text I18n.t('warehousing', default: 'Warehousing fee') + ": _________________________"
    move_down 10
    text I18n.t('insurance') + ": _________________________"
    move_down 10
    2.times do
      text "_" * 85
      move_down 10
    end
    text "<b>#{I18n.t('total_before_taxes')}</b>: _________________________", align: :right, inline_format: true
    move_down 10
    text "TPS / TVH (#{Tax.first.tax1.round(0)}% / 13%): _________________________", align: :right
    move_down 10
    text "TVQ (#{Tax.first.tax2}%): _________________________", align: :right
    move_down 10
    text "<b>#{I18n.t('total_with_taxes')}</b>: _________________________", align: :right, inline_format: true
    move_down 10
    if @quote.deposit.present?
      text "<b>#{I18n.t('deposit_received')}:</b> " + number_to_currency(@quote.deposit.amount) + " - " + I18n.l(@quote.deposit.date, format: :long) + " - " + I18n.t(@quote.deposit.payment_method) + (@quote.deposit.credit_card_type.present? ? "(#{I18n.t(@quote.deposit.credit_card_type)})" : ""), inline_format: true,  align: :right
      move_down 10
    end
    text I18n.t('tip') + ": _________________________", align: :right
    move_down 10
    text "<b>#{I18n.t('amount_to_pay')}</b>: _________________________", align: :right, inline_format: true
    move_down 10

    text "<b><font size='12'>#{I18n.t('payments')}</font></b>", inline_format: true
    move_down 10
    text I18n.t('comptant') + ": ____________ " + " " + I18n.t('debit') + ": ____________ " + " " + I18n.t('credit') + ": ____________  [  ] Visa  [  ] Mastercard"  
    move_down 15

    signatures = [
      ["", "<b>Client</b>", "<b>#{@quote.removal_leader.full_name if @quote.removal_leader_id.present?}</b> - #{I18n.t('removal_team_lead')}"],
      ["Date", "____/____/____", "____/____/____"],
      ["", "", ""],
      ["", "", ""],
      ["Signature", "______________", "______________"]
    ]
    table(signatures, width: PAGE_WIDTH) do
      cells.borders = []
      cells.inline_format = true

      row(0).column(0).padding = [0, 32, 0, 0]
      column(0).align = :right
      column(1..2).align = :center
    end

  end

  def html_to_text(html)
    html = html.gsub("<br>", "\n")
    frag = Nokogiri::HTML::fragment(html)
    frag.css("ul li").each do |node|
      s = Nokogiri::XML::Text.new("•  " + node.inner_html + "\n", node.document)
      node.replace(s)
    end
    frag.css("ol li").each_with_index do |node, index|
      s = Nokogiri::XML::Text.new("#{index + 1}.  " + node.inner_html + "\n", node.document)
      node.replace(s)
    end
    frag.css("p").each do |node|
      unless node.inner_html.strip.empty?
        s = Nokogiri::XML::Text.new(node.inner_html + "\n\n", node.document)
        node.replace(s)
      else
        node.remove
      end
    end
    frag.css("div").each do |node|
      s = Nokogiri::XML::Text.new(node.inner_html + "\n", node.document)
      node.replace(s)
    end
    frag.css("ul").each do |node|
      s = Nokogiri::XML::Text.new(node.inner_html + "\n", node.document)
      node.replace(s)
    end
    frag.css("ol").each do |node|
      s = Nokogiri::XML::Text.new(node.inner_html + "\n", node.document)
      node.replace(s)
    end
    
    CGI.unescapeHTML(frag.to_html)
  end

end