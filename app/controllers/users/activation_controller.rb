class Users::ActivationController < ApplicationController
  skip_authentication

  def show

    @user = User.find_by_token_for(:activation, params[:id])

    if(@user.present?)
      message = t(".already_verified")
      verify_user && message = t(".success") unless @user.verified
      flash[:success] = message
      redirect_to root_path , status: :see_other
    else
      flash[:error] = t(".error")
      render "sessions/new" , status: :unprocessable_content
    end
    
  end


  private 

  def verify_user
    @user.verified = true
    @user.save
  end


end
