class ConsumerMailer < ApplicationMailer
  default from: 'support@specialeyes.london'
 
  def gift_card_email(user, vouchers)
    @user = user
    @url  = 'http://localhost:3000/balance'
    @vouchers = vouchers
    mail(to: @user.email, subject: "You've got a gift card")
  end
end
