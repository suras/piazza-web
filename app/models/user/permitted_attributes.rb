module User::PermittedAttributes
  extend ActiveSupport::Concern

  class_methods do
    def permitted_attributes
      [:name, :email, :password, :password_confirmation, :profile_photo]
    end

    def update_attributes
      [:name, :email, :profile_photo]
    end
  end

end