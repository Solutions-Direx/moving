# encoding: utf-8
class InvoicePdf < Prawn::Document
  include ActionView::Helpers::NumberHelper

  PAGE_WIDTH = 572

  def initialize(invoice)
    super(top_margin: 20, left_margin: 20, right_margin: 20, bottom_margin: 20, page_layout: :portrait)
    @invoice = invoice

    invoice_header
    move_down 10
    invoice_addresses
    move_down 10
    quote_dates
    move_down 10
    stroke_color "CCCCCC"           
    stroke_horizontal_rule
    move_down 10
    price_details

    start_new_page

    payments
    stroke_color "CCCCCC"           
    stroke_horizontal_rule
    move_down 10
    quote_details
  end

  def invoice_header
    table([[company_address_block, invoice_number_block]]) do
      cells.borders = []
      row(0).column(0).padding = [0, 32, 0, 0]
    end
  end

  def invoice_addresses
    table([[quote_address_block, client_address_block]]) do
      cells.borders = []
      row(0).column(0).padding = [0, 22, 0, 0]
    end
  end

  def quote_dates
    table([[quote_date_left, quote_date_right]]) do
      cells.borders = []
      row(0).column(0).padding = [0, 22, 0, 0]
    end
  end

  def quote_date_left
    data = [
      ["<b>#{Quote.model_name.human}:</b> #{@invoice.quote.reference}"],
      ["<b>#{I18n.t 'reserved_on'}:</b> #{I18n.l @invoice.quote.created_at.to_date}"],
      ["<b>#{I18n.t 'approved_on'}:</b> #{I18n.l @invoice.quote.quote_confirmation.approved_at.to_date}"]
    ]

    make_table(data, width: 270, :cell_style => {:border_color => "FFFFFF"}) do
      # cells.padding = [10, 10, 10, 10]
      cells.size = 10
      cells.inline_format = true
    end
  end

  def quote_date_right
    data = [
      ["<b>#{I18n.t 'invoice_date'}:</b> #{I18n.l @invoice.created_at.to_date}"],
      ["<b>#{I18n.t 'prepared_by'}:</b> #{@invoice.creator.full_name}"]
    ]

    make_table(data, width: 270, :cell_style => {:border_color => "FFFFFF"}) do
      # cells.padding = [10, 10, 10, 10]
      cells.size = 10
      cells.inline_format = true
      cells.align = :right
    end
  end

  def price_details
    titles_data = []
    prices_data = []

    if @invoice.total_time_spent > 0
      titles_data << ["#{I18n.t 'time_spent'} (#{@invoice.time_spent} * #{number_to_currency(@invoice.rate)})"] 
      prices_data << [number_to_currency(@invoice.total_time_spent)]
    end

    if (@invoice.try(:gas) || 0) > 0
      titles_data << ["#{I18n.t 'gas'}"]
      prices_data << [number_to_currency(@invoice.gas)] 
    end

    if @invoice.total_surcharges > 0
      @invoice.surcharges.each do |surcharge|
        titles_data << [surcharge.label]
        prices_data << [number_to_currency(surcharge.price)]
      end
    end

    # SUPPLIERS
    if @invoice.invoice_supplies.any?
      titles_data << ["<b><font size='13'>#{I18n.t 'supplies', default: 'Supplies'}</font></b>"]
      prices_data << ["<b><font size='13'> </font></b>"]

      @invoice.invoice_supplies.each do |inv_supply|
        titles_data << ["#{inv_supply.supply.name} (#{inv_supply.quantity} * #{number_to_currency(inv_supply.supply.price)})"]
        prices_data << [number_to_currency(inv_supply.quantity * inv_supply.supply.price)]
      end
    end

    # FORFAIT
    if @invoice.forfaits.any?
      titles_data << ["<b><font size='13'>#{Forfait.model_name.human + 's'}</font></b>"]
      prices_data << ["<b><font size='13'> </font></b>"]

      @invoice.forfaits.each do |forfait|
        titles_data << [forfait.name]
        prices_data << [number_to_currency(forfait.price)]
      end
    end

    if @invoice.quote.quote_confirmation.franchise_cancellation or @invoice.total_insurance_increase > 0
      titles_data << ["<b><font size='13'>#{I18n.t 'insurance'}</font></b>"]
      prices_data << ["<b><font size='13'> </font></b>"]

      # FRANCHISE CANCELLATION

      if @invoice.quote.quote_confirmation.franchise_cancellation
        titles_data << [I18n.t('franchise_cancelation')]
        prices_data << [number_to_currency(@invoice.quote.account.franchise_cancellation_amount)]
      end

      if @invoice.total_insurance_increase > 0
        titles_data << [I18n.t('insurance_increase')]
        prices_data << [number_to_currency(@invoice.total_insurance_increase)]
      end
    end

    if @invoice.quote.to_addresses.present?
      @invoice.quote.to_addresses.each do |to_address|
        if to_address.storage_id && to_address.storage.internal?
          titles_data << ["<b><font size='13'>#{I18n.t 'storage'}: #{to_address.storage.name}</font></b>"]
          prices_data << ["<b><font size='13'> </font></b>"]

          titles_data << ["#{I18n.t('price')} #{I18n.t 'per_month'}"]
          prices_data << [number_to_currency(to_address.price)]

          titles_data << ["#{I18n.t('insurance')}"]
          prices_data << [number_to_currency(to_address.insurance)]
        end
      end
    end

    if @invoice.total_discount > 0
      titles_data << [I18n.t('discount')]
      prices_data << ["- #{number_to_currency(@invoice.total_discount)}"]
    end

    titles_table = make_table(titles_data, width: 270, :cell_style => {:border_color => "FFFFFF"}) do
      # cells.padding = [10, 10, 10, 10]
      cells.size = 10
      cells.inline_format = true
    end

    prices_table = make_table(prices_data, width: 270, :cell_style => {:border_color => "FFFFFF"}) do
      # cells.padding = [10, 10, 10, 10]
      cells.size = 10
      cells.inline_format = true
      cells.align = :right
    end    

    table([[titles_table, prices_table]]) do
      cells.borders = []
      row(0).column(0).padding = [0, 22, 0, 0]
    end

    short_line
    
    # GRAND TOTAL
    titles_data = []
    prices_data = []

    titles_data << ["<b><font size='13'>Grand Total</font></b>"]
    prices_data << ["<b><font size='13'>#{number_to_currency(@invoice.grand_total)}</font></b>"]

    # TAX 1
    if @invoice.tax1_amount > 0
      titles_data << [@invoice.tax1_name]
      prices_data << [number_to_currency(@invoice.tax1_amount)]
    end

    # TAX 2
    if @invoice.tax2_amount > 0
      titles_data << [@invoice.tax2_name]
      prices_data << [number_to_currency(@invoice.tax2_amount)]
    end

    if (@invoice.try(:tip) || 0) > 0
      titles_data << [I18n.t('tip')]
      prices_data << [number_to_currency(@invoice.tip)]
    end

    # DEPOSIT
    if @invoice.quote.deposit
      deposit = @invoice.quote.deposit
      card_type = deposit.credit_card_type.present? ? "(#{I18n.t(deposit.credit_card_type)})" : ""
      titles_data << ["#{I18n.t('deposit_received')} - #{I18n.t(deposit.payment_method)}" + card_type + " - #{I18n.l(deposit.date)}"]
      prices_data << ["- #{number_to_currency(@invoice.quote.deposit.amount)}"]
    end

    titles_table = make_table(titles_data, width: 270, :cell_style => {:border_color => "FFFFFF"}) do
      # cells.padding = [10, 10, 10, 10]
      cells.size = 10
      cells.inline_format = true
    end

    prices_table = make_table(prices_data, width: 270, :cell_style => {:border_color => "FFFFFF"}) do
      # cells.padding = [10, 10, 10, 10]
      cells.size = 10
      cells.inline_format = true
      cells.align = :right
    end    

    table([[titles_table, prices_table]]) do
      cells.borders = []
      row(0).column(0).padding = [0, 22, 0, 0]
    end

    short_line

    # TOTAL
    titles_data = [["<b><font size='13'>Total</font></b>"]]
    prices_data = [["<b><font size='13'>#{number_to_currency(@invoice.total)}</font></b>"]]

    titles_table = make_table(titles_data, width: 370, :cell_style => {:border_color => "FFFFFF"}) do
      # cells.padding = [10, 10, 10, 10]
      cells.size = 10
      cells.inline_format = true
      cells.align = :right
    end

    prices_table = make_table(prices_data, width: 170, :cell_style => {:border_color => "FFFFFF"}) do
      # cells.padding = [10, 10, 10, 10]
      cells.size = 10
      cells.inline_format = true
      cells.align = :right
    end

    table([[titles_table, prices_table]]) do
      cells.borders = []
      row(0).column(0).padding = [0, 22, 0, 0]
    end

  end

  def payments
    if @invoice.payments.any?
      text I18n.t('payments_received'), size: 13, style: :bold
      move_down 5
      @invoice.payments.each do |payment|
        text "•  #{I18n.l(payment.date)}: #{number_to_currency(payment.amount)} - #{payment.payment_option_details}" , leading: 3, size: 11, indent_paragraphs: 10
      end
    end
  end

  def quote_details
    text I18n.t('quote_details', default: 'Quote Details'), size: 16, style: :bold
    move_down 10

    from_data = [["<b><font size='13'>#{@invoice.quote.internal_address? ? I18n.t('internal_moving') : I18n.t('from')}</font></b>"]]

    if @invoice.quote.from_address.has_storage?
      from_data << ["<font size='10'><color rgb='999999'>#{I18n.t('storage').upcase}:</color> #{@invoice.quote.from_address.storage.name}</font>"]
      from_data << [address_for(@invoice.quote.from_address.storage.address)]
    else
      from_data << ["<color rgb='999999'><font size='10'>#{I18n.t('address').upcase}</font></color>"]
      from_data << [address_for(@invoice.quote.from_address.address)]
    end

    from_table = make_table(from_data, width: 275) do
      cells.inline_format = true
      cells.padding = [10, 10, 10, 10]
      cells.size = 11
      cells.style(background_color: "f5f5f5", border_color: "CCCCCC")

      row(0).style(borders: [:top, :left, :right], padding: [10, 10, 0, 10])
      row(1).style(borders: [:left, :right], padding: [10, 10, 0, 10])
      row(2).style(borders: [:bottom, :left, :right])
    end

    unless @invoice.quote.internal_address?
      to_data = [["<b><font size='13'>#{I18n.t('to')}</font></b>"]]
      unless @invoice.quote.to_addresses.blank?
        for to_address in @invoice.quote.to_addresses
          if to_address.has_storage?
            internal = to_address.storage_id && to_address.storage.internal? ? I18n.t('internal') : ''
            to_data << ["<font size='10'><color rgb='999999'>#{I18n.t('storage').upcase}:</color> #{to_address.storage.name} #{internal}</font>"]
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

    move_down 10
    removal_men = @invoice.quote.removal_men.any? ? "- #{@invoice.quote.removal_men.map(&:full_name).to_sentence}" : ""
    text "<b>#{I18n.t('removal_men', default: 'Removal men')}</b>: #{@invoice.quote.num_of_removal_man} #{removal_men}", inline_format: true
    text "<b>#{I18n.t('price')}</b>: #{number_to_currency(@invoice.quote.price, strip_insignificant_zeros: true)} #{I18n.t('per_hour')}", inline_format: true
    text "<b>#{I18n.t('gas')}</b>: #{number_to_currency(@invoice.quote.gas, strip_insignificant_zeros: true)}", inline_format: true
    if @invoice.quote.surcharges.any?
      @invoice.quote.surcharges.each do |surcharge|
        text "<b>#{surcharge.label}</b>: #{number_to_currency(surcharge.price, strip_insignificant_zeros: true)}", inline_format: true
      end
    end

    long_distance = @invoice.quote.long_distance ? "(#{I18n.t('long_distance')})" : ""
    text "<b>#{I18n.t('transport_time', default: 'Transport time')}</b>: #{@invoice.quote.transport_time} #{long_distance}", inline_format: true
  end

  def short_line
    empty_table = make_table([[""]], width: 370, :cell_style => {:border_color => "FFFFFF", :borders => []})
    line_table = make_table([[""]], width: 170, :cell_style => {:border_color => "CCCCCC", :borders => [:top]}) do
      cells.align = :right
    end

    table([[empty_table, line_table]]) do
      cells.borders = []
      row(0).column(0).padding = [0, 22, 0, 0]
    end
  end

  def invoice_number_block
    data = [["#{Invoice.model_name.human} ##{@invoice.code}"]]
    make_table(data, width: 270, :cell_style => {:border_color => "FFFFFF"}) do
      # cells.padding = [10, 10, 10, 10]
      rows(0).style(size: 22, font_style: :bold, align: :right)
    end
    # text "#{Invoice.model_name.human} ##{@invoice.code}", size: 22, style: :bold
  end

  def company_address_block
    data = [[@invoice.quote.company.invoice_header]]
    make_table(data, width: 270, :cell_style => {:border_color => "FFFFFF"}) do
      # cells.padding = [10, 10, 10, 10]
      rows(0).size = 10
    end
  end

  def quote_address_block
    data = [["<b>#{@invoice.quote.company.company_name}</b>"]]
    data << ["<i>#{address_for(@invoice.quote.company.address)}</i>"] if @invoice.quote.company.address.present?
    data << ["<b>#{I18n.t 'phone'}:</b> #{@invoice.quote.company.phone}"]
    data << ["<b>#{I18n.t 'website'}</b>: #{@invoice.quote.company.website}"]

    make_table(data, width: 275) do
      cells.inline_format = true
      cells.padding = [10, 10, 10, 10]
      cells.size = 11
      cells.style(background_color: "f5f5f5", border_color: "CCCCCC")

      row(0).style(borders: [:top, :left, :right], padding: [10, 10, 0, 10])
      row(1..data.size - 2).style(borders: [:left, :right], padding: [10, 10, 0, 10])
      row(data.size - 1).style(borders: [:bottom, :left, :right])
    end
  end

  def client_address_block
    data = [
      ["<b>#{@invoice.quote.client.name_with_code}</b>"],
      ["<i>#{address_for @invoice.quote.billing_address.address}</i>"],
      ["<b>#{I18n.t 'removal_at'}:</b> #{I18n.l @invoice.quote.removal_at.to_date}"]
    ]

    make_table(data, width: 275) do
      cells.inline_format = true
      cells.padding = [10, 10, 10, 10]
      cells.size = 11
      cells.style(background_color: "f5f5f5", border_color: "CCCCCC")

      row(0).style(borders: [:top, :left, :right], padding: [10, 10, 0, 10])
      row(1).style(borders: [:left, :right], padding: [10, 10, 0, 10])
      row(2).style(borders: [:bottom, :left, :right])
    end
  end

  def address_for(address)
    optional_address = [address.city, address.province, address.postal_code].select{|s| s.present?}.join(", ")
    address.address + "\n" + optional_address
  end

end