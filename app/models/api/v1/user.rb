# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  user_name       :string(50)       not null
#  user_lastname   :string(50)       not null
#  password_digest :string           not null
#  email           :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Api::V1::User < ActiveRecord::Base
  has_secure_password

  validates :user_name, presence: true
  validates :user_name, length: { maximum: 50 }
  validates :user_lastname, presence: true
  validates :user_lastname, length: { maximum: 50 }
  validates :email, presence: true
  validates :email, uniqueness: {case_sensitive: false}
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }
  
end
