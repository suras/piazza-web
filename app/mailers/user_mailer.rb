class UserMailer < ApplicationMailer
  before_action { @user = params[:user] }

  default to: -> { %("#{@user.name}"<#{@user.email} >)}


  def password_reset(token)
    @password_reset_token = token

    mail subject: t(".subject")
  end

  def activation(token)
    @activation_token = token

    mail subject: t(".subject")
  end

  def renew(token, listing_id)
     @login_token = token
     @listing_id = listing_id
     mail subject: t(".subject")
  end
end
