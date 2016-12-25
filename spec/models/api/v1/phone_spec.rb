# == Schema Information
#
# Table name: phones
#
#  id           :integer          not null, primary key
#  country_code :string(5)        not null
#  area_code    :string(5)        not null
#  phone_number :string(15)       not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'rails_helper'

module Api::V1
  RSpec.describe Phone, type: :model do
    subject { FactoryGirl.create :phone }

    it { should validate_presence_of(:country_code) }
    it { should validate_length_of(:country_code).is_at_most(5) }
    it { should validate_presence_of(:area_code) }
    it { should validate_length_of(:area_code).is_at_most(5) }
    it { should validate_presence_of(:phone_number) }
    it { should validate_length_of(:phone_number).is_at_most(15) }
  end
end