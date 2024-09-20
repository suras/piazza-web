class SaveListingsChannel < ApplicationCable::Channel
  extend Turbo::Streams::StreamName
  include Turbo::Streams::StreamName::ClassMethods


  def subscribed
      stream_from stream_name
  end

  private 

    def stream_name
      @stream_name ||= verified_stream_name_from_params
    end

    def user
      @user ||= GlobalID::Locator.locate(stream_name)
    end

end