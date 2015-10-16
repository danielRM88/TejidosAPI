# == Schema Information
#
# Table name: clients
#
#  id           :integer          not null, primary key
#  client_name  :string(50)       not null
#  type_id      :string(5)        not null
#  number_id    :string(50)       not null
#  address      :string(255)
#  email        :string(25)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  client_state :string(20)       default("CURRENT"), not null
#

FactoryGirl.define do
  factory :client do
    client_name "Daniel Rosato"
    type_id     "V"
    number_id   "18358068"
    address     "av. Chacao, Macaracuay, Caracas"
    email       "rosato.daniel@gmail.com"
  end
end