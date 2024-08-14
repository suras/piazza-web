class ApplicationController < ActionController::Base
    include Authenticate
    include SetCurrentRequestDetails

    include Pagy::Backend

    helper_method :turbo_frame_request?
end
