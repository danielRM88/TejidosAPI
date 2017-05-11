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

class Api::V1::Inventory < ActiveRecord::Base
  belongs_to :purchase, inverse_of: :inventories
  belongs_to :fabric
  has_many :existences
  has_many :sales

  validates :purchase, presence: true
  validates :fabric, presence: true
  validates :pieces, presence: true
  validates :pieces, numericality: { greater_than: 0, only_integer: true }
  validates :amount, presence: true
  validates :amount, numericality: { greater_than: 0 }
  validates :unit, presence: true
  validates :unit, length: { maximum: 15 }
  validates :unit_price, presence: true
  validates :unit_price, numericality: { greater_than: 0 }

  def subtotal
    return (self.pieces*self.unit_price)
  end
end
