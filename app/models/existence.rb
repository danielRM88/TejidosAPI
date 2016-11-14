# == Schema Information
#
# Table name: existences
#
#  id           :integer          not null, primary key
#  inventory_id :integer          not null
#  pieces       :integer          not null
#  amount       :decimal(10, 2)   not null
#  unit         :string(15)       not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Existence < ActiveRecord::Base
  belongs_to :inventory

  validates :inventory, presence: true
  validates :pieces, presence: true
  validates :pieces, numericality: { greater_than: 0, only_integer: true }
  validates :amount, presence: true
  validates :amount, numericality: { greater_than: 0 }
  validates :unit, presence: true
  validates :unit, length: { maximum: 15 }
end
