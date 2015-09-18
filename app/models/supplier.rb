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

class Supplier < ActiveRecord::Base
  has_and_belongs_to_many :phones
end
