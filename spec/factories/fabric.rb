# == Schema Information
#
# Table name: fabrics
#
#  id           :integer          not null, primary key
#  code         :string(20)       not null
#  description  :string(255)
#  color        :string(50)
#  unit_price   :decimal(18, 2)   not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  fabric_state :string(20)       default("CURRENT"), not null
#

FactoryGirl.define do
  factory :fabric, class: Fabric do
    code        "RJ0001"
    description "Red Jersey"
    color       "red"
    unit_price  2500.50
  end
  factory :fabric2, class: Fabric do
    code        "BL0001"
    description "Blue Jersey"
    color       "blue"
    unit_price  3000
  end
  factory :fabric3, class: Fabric do
    code        "RR0002"
    description "Pink Jersey"
    color       "pink"
    unit_price  2000
  end
  factory :fabric4, class: Fabric do
    code        "WH0001"
    description "White Jersey"
    color       "white"
    unit_price  1500
  end
  factory :fabric5, class: Fabric do
    code        "KK8972"
    description "Red RIP"
    color       "red"
    unit_price  200
  end
  factory :fabric6, class: Fabric do
    code        "2k23lk"
    description "Blue RIP"
    color       "blue"
    unit_price  250
  end
  factory :fabric7, class: Fabric do
    code        "laskjd"
    description "Grey RIP"
    color       "grey"
    unit_price  250
  end
  factory :fabric8, class: Fabric do
    code        "KJ9999"
    description "Killer Joe"
    color       "black"
    unit_price  750
  end
end