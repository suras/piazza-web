class Listings::RenewController < ApplicationController

  skip_authorization only: :show

  skip_authentication only: :show


  before_action :load_user, :load_listing

  def show
    @listing.published_on = Time.now unless @listing.renew_date_past?
    if(@listing.save)
      puts "saving publised on"
      redirect_to listing_path(@listing), flash: { success: t(".success")}, status: :see_other
    else
      render "listings/new", status: :unprocessable_content
    end
  end

  private 

  def load_listing
    @listing = Listing.find(params[:id])
  end

  def load_user
    @user = Current.user || User.find_by_token_for(:authenticate, params[:token])
   
    redirect_to root_path,
      status: :see_other,
      flash: {
      error: t("listings.renew.invalid_link")
    } unless @user.present?
  end

end
