module User::Activation
   extend ActiveSupport::Concern


   included do
     generates_token_for :activation
     after_create :send_activation_mail
   end


   def send_activation_mail
    token = generate_token_for :activation
    UserMailer.with(user: self).activation(token).deliver_now 
   end


end