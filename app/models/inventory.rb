# == Schema Information
#
# Table name: inventories
#
#  id          :integer          not null, primary key
#  purchase_id :integer          not null
#  fabric_id   :integer          not null
#  pieces      :integer          not null
#  amount      :decimal(10, 2)   not null
#  unit        :string(15)       not null
#  unit_price  :decimal(18, 2)   not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Inventory < ActiveRecord::Base
end
