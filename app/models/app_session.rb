# == Schema Information
#
# Table name: app_sessions
#
#  id           :bigint           not null, primary key
#  token_digest :string
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  user_id      :bigint           not null
#
# Indexes
#
#  index_app_sessions_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class AppSession < ApplicationRecord
  belongs_to :user

  has_secure_password :token, validations: false

  before_create {
    self.token = self.class.generate_unique_secure_token
  }


  def to_h 
     {
       user_id: user.id,
       app_session: id,
       token: self.token
     }

  end

end
