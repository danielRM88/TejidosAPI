# == Schema Information
#
# Table name: sales
#
#  id           :integer          not null, primary key
#  invoice_id   :integer          not null
#  inventory_id :integer          not null
#  pieces       :integer          not null
#  amount       :decimal(10, 2)   not null
#  unit         :string(15)       not null
#  unit_price   :decimal(18, 2)   not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Sale < ActiveRecord::Base
  belongs_to :invoice
  belongs_to :inventory
end
