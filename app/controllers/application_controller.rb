class ApplicationController < ActionController::Base
    include Authenticate
    include SetCurrentRequestDetails

    helper_method :turbo_frame_request?
end
