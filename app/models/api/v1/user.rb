# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  user_name       :string(50)       not null
#  user_lastname   :string(50)       not null
#  password_digest :string           not null
#  email           :string           default(""), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Api::V1::User < ActiveRecord::Base
  has_secure_password
end
