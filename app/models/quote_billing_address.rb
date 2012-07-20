class QuoteBillingAddress < QuoteAddress
  has_one :address, :as => :addressable, :dependent => :destroy
  accepts_nested_attributes_for :address

  after_save :update_invoice_tax

  def update_invoice_tax
    invoice = quote.invoice

    if invoice.present?
      invoice.copy_tax_setting_from(quote.tax)
      invoice.save!
    end
  end
end