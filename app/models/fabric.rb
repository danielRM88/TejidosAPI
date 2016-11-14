# == Schema Information
#
# Table name: fabrics
#
#  id           :integer          not null, primary key
#  code         :string(20)       not null
#  description  :string(255)
#  color        :string(50)
#  unit_price   :decimal(18, 2)   not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  fabric_state :string(20)       default("CURRENT"), not null
#

class Fabric < ActiveRecord::Base

  include StateManager

  has_many :inventories

  validates :code, presence: true
  validates :code, length: { maximum: 20 }
  validates :code, uniqueness: {case_sensitive: false, scope: :fabric_state}, if: :current?
  validates :description, length: { maximum: 255 }
  validates :color, length: { maximum: 50 }
  validates :unit_price, presence: true
  validates :unit_price, numericality: { greater_than: 0 }
  validates :fabric_state, presence: true
  validates :fabric_state, length: { maximum: 20 }
  validates :fabric_state, inclusion: { in: STATES, message: "%{value} is not a valid fabric_state" }

  def get_state
    self.fabric_state
  end

  def get_state_field
    return :fabric_state
  end

  def change_state state
    self.fabric_state = state
  end

  def count_dependencies
    self.inventories.count
  end
end
