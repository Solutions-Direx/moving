# coding: utf-8
class Mailer < ActionMailer::Base
  add_template_helper(BootstrapHelper)
  
  default from: "from@example.com"
  
  def user_created_email(user, generated_password)
    @user = user
    @generated_password = generated_password
    
    mail(to: @user.email, subject: "#{t 'account_created', default: 'Account created'}")
  end
  
  def quote_email(quote)
    @quote = quote
    mail(to: @quote.client.email, subject: "#{t 'quote_information', default: 'Quote information'}")
  end
  
  def invoice_email(invoice)
    @quote = invoice.quote
    @invoice = invoice
    mail(to: @quote.client.email, subject: "#{Invoice.model_name.human}")
  end
end