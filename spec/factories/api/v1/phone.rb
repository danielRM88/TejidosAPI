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

FactoryGirl.define do
  factory :phone, class: Api::V1::Phone do
    country_code "58"
    area_code    "0212"
    phone_number "1234567"
  end
end