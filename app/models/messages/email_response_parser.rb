class Messages::EmailResponseParser
  include ActionView::Helpers::SanitizeHelper
  
  def initialize(mail)
    @mail = mail
  end
    
    def plain_text_body
      @email_body ||= if @mail.text_part.present?
        @mail.text_part.body.decoded
      else
        strip_tags @mail.body.decoded
      end
    end
  end