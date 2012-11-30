class Invoice < ActiveRecord::Base
  include Taxable
  include Signable
  include PgSearch
  multisearchable :against => [:code]
  pg_search_scope :search_by_keyword, 
                  :against => :code,
                  :associated_against  => {
                    :quote => :code,
                    :client => :name
                  },
                  :using => { 
                    :tsearch => {
                      :prefix => true # match any characters
                    } 
                  },
                  :ignoring => :accents
                  
  belongs_to :quote
  belongs_to :client
  belongs_to :tax
  belongs_to :creator, :class_name => "User", :foreign_key => "creator_id"
  
  has_many :invoice_forfaits, :dependent => :destroy
  has_many :forfaits, :through => :invoice_forfaits

  has_many :payments, :as => :payable, :dependent => :destroy
  accepts_nested_attributes_for :payments, :allow_destroy => true, :reject_if => lambda {|p| p['amount'].blank? && p['date'].blank? && p['payment_method'].blank?}
  
  has_one :account, :through => :quote
  
  has_many :invoice_supplies, :dependent => :destroy
  has_many :supplies, :through => :invoice_supplies
  accepts_nested_attributes_for :invoice_supplies, :allow_destroy => true, :reject_if => lambda {|qs| qs[:quantity].blank? || qs[:supply_id].blank?}
  
  has_many :surcharges, :as => :surchargeable, :dependent => :destroy
  accepts_nested_attributes_for :surcharges, :allow_destroy => true, :reject_if => :all_blank
  
  attr_accessor :amount_received
  attr_accessible :comment, :signature, :signer_name, :time_spent, :quote_id, :gas, :rate,
                  :invoice_supplies_attributes, :forfait_ids, :client_satisfaction, :tip,
                  :payment_method, :discount, :credit_card_type, :surcharges_attributes, :lock_version,
                  :too_big_for_stairway, :too_big_for_hallway, :too_big, :broken, :too_fragile, :furnitures,
                  :tax1, :tax1_label, :tax2, :tax2_label, :compound, :purchase_order, :creator_id
  
  before_create :generate_code
  after_create :mark_quote_invoiced
  
  validates_presence_of :payment_method, :unless => Proc.new { |invoice| invoice.quote.client.commercial? }
  validates_numericality_of :discount, greater_than: 0, allow_blank: true
  
  def build_lines
    lines = []

    # 1. moving line
    moving_line = OpenStruct.new
    moving_line.name = 'moving'
    moving_line.amount = total_time_spent + (try(:gas) || 0) + total_surcharges + total_forfaits - total_discount
    lines << moving_line

    # 2. supplier line 
    supplier_line = OpenStruct.new
    supplier_line.name = 'supply'
    supplier_line.amount = total_supplies
    lines << supplier_line

    # 3. insurance line 
    insurance_line = OpenStruct.new
    insurance_line.name = 'insurance'
    insurance_line.amount = total_franchise_cancellation + total_insurance_increase + storages_amount + total_tv_insurance
    lines << insurance_line

    # 4. tip line 
    tip_line = OpenStruct.new
    tip_line.name = 'tip'
    tip_line.amount = (try(:tip) || 0)
    lines << tip_line

    lines
  end

  # cache grand_total calculation since it's expensive
  # pass recalculate = true to recalculate
  def grand_total(recalculate = false)
    if @grand_total.nil? || recalculate
      @grand_total = item_total(recalculate) - total_discount
      @grand_total = 0 if @grand_total < 0
    end
    @grand_total
  end

  def item_total(recalculate = false)
    if @item_total.nil? || recalculate
      @item_total = total_time_spent + 
                     (try(:gas) || 0) + 
                     total_surcharges + 
                     total_supplies + 
                     total_forfaits + 
                     total_franchise_cancellation + 
                     total_insurance_increase + 
                     total_tv_insurance + 
                     storages_amount
    end
    @item_total
  end

  # alias subtotal for Taxable module
  alias :subtotal :grand_total
  
  def total_discount
    number_or_zero(:discount).round(2)
  end
  
  def total_surcharges
    sum = 0
    if surcharges.any?
      surcharges.each do |surcharge|
        sum += (surcharge.try(:price) || 0)
      end
    end
    sum.round(2)
  end
  
  def total_time_spent
    (number_or_zero(:time_spent) * number_or_zero(:rate)).round(2)
  end
  
  def total_supplies
    sum = 0
    if invoice_supplies.any?
      invoice_supplies.each do |inv_supply|
        sum += inv_supply.quantity * inv_supply.supply.price
      end
    end
    sum.round(2)
  end
  
  def total_forfaits
    sum = 0
    if forfaits.any?
      forfaits.each do |forfait|
        sum += forfait.price
      end
    end
    sum.round(2)
  end
  
  def total_franchise_cancellation
    quote.quote_confirmation.franchise_cancellation ? quote.account.franchise_cancellation_amount : 0
  end
  
  def total_insurance_increase
    quote.quote_confirmation.insurance_limit_enough ? 0 : (quote.quote_confirmation.try(:insurance_increase) || 0).round(2)
  end

  def total_tv_insurance
    quote.quote_confirmation.tv_insurance ? (quote.quote_confirmation.try(:tv_insurance_price) || 0).round(2) : 0
  end

  def storages_amount
    t = 0
    if quote.to_addresses.present?
      quote.to_addresses.each do |to_address|
        if to_address.storage_id && to_address.storage.internal?
          t += (to_address.try(:insurance) || 0) + (to_address.try(:price) || 0)
        end
      end
    end
    t
  end

  def total
    t = total_with_taxes + (try(:tip) || 0)
    t -= quote.deposit.amount if quote.deposit
    t = 0 if t < 0
    t
  end

  def copy_quote_info
    self.rate = quote.price
    self.gas = quote.gas
    quote.quote_supplies.each do |qs|
      self.invoice_supplies.build(supply_id: qs.supply_id, quantity: qs.quantity)
    end
    quote.quote_forfaits.each do |qf|
      self.invoice_forfaits.build(forfait_id: qf.forfait_id)
    end
    quote.surcharges.each do |s|
      self.surcharges.build(label: s.label, price: s.price)
    end
    
    # get tax base on delivery province
    tax = quote.tax
    copy_tax_setting_from(tax)
  end

  def amount_received
    unless @amount_received
      t = 0
      payments.select{|p| !p.new_record?}.each do |payment|
        t += payment.amount
      end
      @amount_received = t.round(2)
    end
    @amount_received
  end
  
  def amount_left
    t = (total - amount_received).round(2)
    t = 0 if t < 0
    t
  end

  def self.export(account, quote_ids=[], options={})
    headers = %w{Invoice_number UDF_1 Customer_Code Invoice_Date Order_number ship_date
                Sales_person WHS_Location Currency Customer_name Contact_name Address1 
                Address2 city Province Country  PostCode email Phone1 Phone2 Fax2 
                website Shipto_Name Shipto_contact ship_address1 ship_address2 ship_city ship_province
                ship_zip ship_country ship_phone ship_phone_2 ship_fax ship_email Net_Days Net_disc_percent
                net_disc_days invoice_comment Header_GL_Account Payment_method CC_name payment_text record_type
                shipper tracking_number add_info1 add_Date line_number item_code item_description
                UOM qty_ordered qty_shipped qty_bo base_price line_disc_percent unit_price amount tax_code
                Detail_GL_account Department Project Freight_Line}
    header_indexes = Hash[headers.map.with_index{|*x| x}]
                
    quotes = account.quotes.includes(:client, :quote_confirmation, :deposit, :invoice, :forfaits, :surcharges, :supplies).order('created_at DESC')
    quotes = quotes.where(id: quote_ids) if quote_ids.present?

    CSV.generate(options) do |csv|
      csv << headers
      quotes.each do |quote|
        data = {}
        invoice = quote.invoice
        invoice.build_lines.select{|l| l.amount > 0}.each_with_index do |line, index|
          data["Invoice_number"] = invoice.code
          data["Customer_Code"] = quote.client.code
          data["Invoice_Date"] = I18n.l(invoice.updated_at.to_date, format: :default)
          data["Sales_person"] = quote.try(:creator).try(:full_name)
          data["Currency"] = "CAD"
          data["Customer_name"] = quote.client.name
          data["Contact_name"] = quote.client.try(:billing_contact)
          data["Address1"] = quote.client.address.address
          data["city"] = quote.client.address.try(:city)
          data["Province"] = quote.client.address.try(:province)
          data["Country"] = quote.client.address.try(:country)
          data["PostCode"] = quote.client.address.try(:postal_code)
          data["email"] = quote.client.try(:email)
          data["Phone1"] = quote.client.try(:phone1)
          data["Phone2"] = quote.client.try(:phone2)
          data["Payment_method"] = invoice.payment_method
          data["CC_name"] = invoice.credit_card_type.present? ? I18n.t(invoice.credit_card_type) : ''
          data["payment_text"] = ""
          data["line_number"] = index + 1
          data["invoice_comment"] = "#{Quote.model_name.human} ##{quote.code} / Client #{quote.client.code}"
          data["item_description"] = line.name
          data["amount"] = line.amount
          data["tax_code"] = line.name == 'tip'? "" : "TPS_TVQ"
          data["Detail_GL_account"] = account.send("accounting_#{line.name}_account_number")

          row = []
          header_indexes.each do |field, index|
            row << data[field] || ''
          end
          csv << row
        end
      end
    end

  end
  
private

  def generate_code
    last_invoice = Invoice.last
    account = quote.company.account
    # force new invoice code
    if account.rebase_invoice_number
      last_code = account.invoice_start_number
      account.rebase_invoice_number = false
      account.save!(validation: false)
    else
      last_code = last_invoice ? last_invoice.code : account.invoice_start_number
    end
    
    self.code = last_code + 1
  end
  
  def number_or_zero(field)
    try(field) || 0
  end

  def mark_quote_invoiced
    quote.invoiced = true
    quote.save
  end
end