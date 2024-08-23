module User::PermittedAttributes
  extend ActiveSupport::Concern

  class_methods do
    def permitted_attributes
      [:name, :email, :password, :password_confirmation]
    end

    def update_attributes
      [:name, :email]
    end
  end

end