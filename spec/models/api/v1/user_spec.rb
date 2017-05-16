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

require 'rails_helper'

module Api::V1
  RSpec.describe User, type: :model do
  end
end
