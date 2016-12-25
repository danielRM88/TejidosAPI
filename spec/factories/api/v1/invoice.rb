# == Schema Information
#
# Table name: invoices
#
#  id              :integer          not null, primary key
#  client_id       :integer          not null
#  iva_id          :integer          not null
#  invoice_number  :string(50)       not null
#  subtotal        :decimal(18, 2)   not null
#  invoice_date    :date             not null
#  form_of_payment :string(155)      not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  invoice_state   :string(20)       default("CURRENT"), not null
#

FactoryGirl.define do
  factory :invoice, class: Api::V1::Invoice do
    client { FactoryGirl.create :client }
    iva { FactoryGirl.create :iva }
    invoice_number "000001-z"
    subtotal 10000
    invoice_date Date.new
    form_of_payment "CASH"
  end
end