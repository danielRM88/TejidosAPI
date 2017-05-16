# == Schema Information
#
# Table name: purchases
#
#  id              :integer          not null, primary key
#  supplier_id     :integer          not null
#  iva_id          :integer          not null
#  purchase_number :string(50)       not null
#  subtotal        :decimal(18, 2)   not null
#  form_of_payment :string(155)
#  purchase_date   :date             not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  purchase_state  :string(20)       default("CURRENT"), not null
#

FactoryGirl.define do
  factory :purchase, class: Api::V1::Purchase do
    supplier_id     1
    vat          12
    purchase_number "01-00001"
    subtotal        250000
    form_of_payment "credit"
    purchase_date   Time.zone.today
  end
  factory :purchase2, class: Api::V1::Purchase do
    supplier_id     2
    vat          12
    purchase_number "001501"
    subtotal        156090.255
    form_of_payment "check"
    purchase_date   Date.parse("18/10/2015")
  end
end