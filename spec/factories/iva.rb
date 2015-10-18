# == Schema Information
#
# Table name: ivas
#
#  id         :integer          not null, primary key
#  percentage :decimal(5, 2)    not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :iva, class: Iva do
    percentage  14
  end
  factory :iva2, class: Iva do
    percentage  13
  end
  factory :iva3, class: Iva do
    percentage  12
  end
end