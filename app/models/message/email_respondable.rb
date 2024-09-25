module Message::EmailRespondable
  extend ActiveSupport::Concern

  included do
    class_attribute :email_message_verifier,
    default: Rails.application.message_verifier("Message/EmailRespondable"),
    instance_accessor: false
  end 
  
  def response_email(recipient)
    identifier = email_reply_identifier(recipient)
    "conversation+#{identifier}@#{inbound_email_domain}"
  end  

  class_methods do
    def decode_email_reply_identifier(identifier)
       identifier = email_message_verifier.verify(identifier)

       identifier.split(":").map do |gid|
         GlobalID::Locator.locate(gid)
       end
    end
  end

  private 

  def email_reply_identifier(recipient)
    identifier = "#{conversation.to_gid_param}:#{recipient.to_gid_param}"
    self.class.email_message_verifier.generate(identifier)
  end

  def inbound_email_domain
    Rails.application.config.inbound_email_domain
  end

end  