class SessionsController < ApplicationController
    skip_authentication only: [:new, :create]


    def new 

    end    

    def create
        @app_session = User.create_app_session(
             email: login_params[:email],
             password: login_params[:password]
             )
        if @app_session
            log_in(@app_session, login_params[:remember_me])
            flash[:success] = t(".success")
            redirect_to root_path, status: :see_other  
        else 
           flash.now[:danger] = t(".incorrect_details")
           render "sessions/new", status: :unprocessable_content 
        end    
    end 
    
    def destroy
       log_out
       flash[:success] = t(".success")
       redirect_to root_path, status: :see_other
    end

    private 

    def login_params
      @login_params ||= params.require(:user).permit(:email, :password, :remember_me)
    end    

end
