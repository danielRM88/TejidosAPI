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

class Api::V1::Sale < ActiveRecord::Base
  belongs_to :invoice, inverse_of: :sales
  belongs_to :inventory

  validates :invoice, presence: true
  validates :inventory, presence: true
  validates :pieces, presence: true
  validates :pieces, numericality: { greater_than: 0, only_integer: true }
  validates :amount, presence: true
  validates :amount, numericality: { greater_than: 0 }
  validates :unit, presence: true
  validates :unit, length: { maximum: 15 }
  validates :unit_price, presence: true
  validates :unit_price, numericality: { greater_than: 0 }

  def subtotal
    return (self.unit_price*self.amount)
  end

  def as_json(options = { })
    json = super(options)
    json[:fabric_data] = fabric_data
    json
  end

  def fabric_data
    return self.inventory.fabric_data
  end
end
