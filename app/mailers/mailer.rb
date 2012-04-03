class Mailer < ActionMailer::Base
  default from: "from@example.com"
  
  def user_created_email(user, generated_password)
    @user = user
    @generated_password = generated_password
    
    mail(to: @user.email, subject: "Account created")
  end
end
