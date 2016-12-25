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
  factory :client, class: Client do
    client_name "Daniel Rosato"
    type_id     "V"
    number_id   "18358068"
    address     "av. Chacao, Macaracuay, Caracas"
    email       "rosato.daniel@gmail.com"
  end
  factory :client2, class: Client do
    client_name "Mauro Rosato"
    type_id     "V"
    number_id   "5218452"
    address     "av. Chacao, Macaracuay, Caracas"
    email       "maurorosato1@gmail.com"
  end
  factory :client3, class: Client do
    client_name "Fabiola Rosato"
    type_id     "V"
    number_id   "20653663"
    address     "av. Chacao, Macaracuay, Caracas"
    email       "fabix182@gmail.com"
  end
  factory :client4, class: Client do
    client_name "Cristina Monaco"
    type_id     "V"
    number_id   "4885796"
    address     "av. Chacao, Macaracuay, Caracas"
    email       "fabix182@gmail.com"
  end
end