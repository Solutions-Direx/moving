# coding: utf-8
class Mailer < ActionMailer::Base
  add_template_helper(BootstrapHelper)
  
  #default from: "from@example.com"
  
  def user_created_email(user, generated_password)
    @user = user
    @generated_password = generated_password
    
    mail(from: "<#{@user.account.owner.email}>", to: @user.email, subject: "#{t 'account_created', default: 'Account created'}")
  end
  
  def quote_email(quote)
    @quote = quote
    mail(from: "#{@quote.company.try(:company_name)} <#{@quote.creator.email}>", to: @quote.client.email, 
         subject: "#{t 'quote_information', default: 'Quote information'}")
  end
  
  def invoice_email(invoice)
    @quote = invoice.quote
    @invoice = invoice
    mail(from: "#{@invoice.quote.company.try(:company_name)} <#{@invoice.quote.creator.email}>", to: @quote.client.email, 
         subject: "#{Invoice.model_name.human}")
  end
end