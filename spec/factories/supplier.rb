# == Schema Information
#
# Table name: suppliers
#
#  id             :integer          not null, primary key
#  supplier_name  :string(155)      not null
#  type_id        :string(5)        not null
#  number_id      :string(50)       not null
#  address        :string(255)
#  email          :string(25)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  supplier_state :string(20)       default("CURRENT"), not null
#

FactoryGirl.define do
  factory :supplier, class: Supplier do
    supplier_name "Fabrica de Tejidos de Punto Monaco"
    type_id       "J"
    number_id     "123456789"
    address       "esq. El Cuji, La Candelaria, Caracas"
    email         "fabrica@puntomonaco.com"
  end
  factory :supplier2, class: Supplier do
    supplier_name "Wisan's CO."
    type_id       "J"
    number_id     "987654321"
    address       "San Bernardino, Caracas"
    email         "info@wisanco.com"
  end
  factory :supplier3, class: Supplier do
    supplier_name "Textiles CA."
    type_id       "J"
    number_id     "555555555"
    address       "La Candelaria, Caracas"
    email         "info@textiles.com"
  end
  factory :supplier4, class: Supplier do
    supplier_name "Fabrics Empire"
    type_id       "J"
    number_id     "55555565685"
    address       "El Llanito, Caracas"
    email         "info@empire.com"
  end
  factory :supplier5, class: Supplier do
    supplier_name "Shirts Emporium"
    type_id       "J"
    number_id     "99993829"
    address       "La Castellana, Caracas"
    email         "info@emporium.com"
  end
  factory :supplier6, class: Supplier do
    supplier_name "Fabrics Builder"
    type_id       "J"
    number_id     "1327383992"
    address       "La Miranda, Caracas"
    email         "info@builder.com"
  end
end