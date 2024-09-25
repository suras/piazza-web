class ConversationMailbox < ApplicationMailbox
  before_processing :decode_identifier
  before_processing :require_conversation


  def process
    # Rails.logger.info "Processing message +++++++++++++++++++++"
    parser = Messages::EmailResponseParser.new(mail)

    @conversation.messages.create(
      body: parser.parsed_body,
      from: @from,
      sender: sender
    )
    # Rails.logger.info "created from +++++++++++++++++++++#{@from}"
    # Rails.logger.info "created send +++++++++++++++++++++#{sender.id}"
    # Rails.logger.info "created body +++++++++++++++++++++#{parser.plain_text_body}"

    # Rails.logger.info "created message +++++++++++++++++++++#{@conversation.id}"

  end


  private
    def decode_identifier
      # Rails.logger.info "Decoding message +++++++++++++++++++++"
       @conversation, @from = Message.decode_email_reply_identifier(signed_identifier)
    rescue    ActiveSupport::MessageVerifier::InvalidSignature
      bounce_with_error_email
    end

    def require_conversation
      bounce_with_error_email unless @conversation.present?
    end

    def signed_identifier
      mail.recipients.find do |recipient|
         /conversation/.match? recipient
      end.split("@").first.split("+").second
    end 

    def bounce_with_error_email
      bounce_with ConversationMailer.email_response_error(mail.from.first)
    end
    
    def sender
      # Rails.logger.info "Finding user +++++++++++++++++++++#{mail.from.first}"
       User.find_by(email: mail.from.first)
    end  
end
