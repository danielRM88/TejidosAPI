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

class Api::V1::Supplier < ActiveRecord::Base

  include StateManager

  has_many :purchases
  has_and_belongs_to_many :phones

  validates :supplier_name, presence: true
  validates :supplier_name, length: { maximum: 155 }
  validates :type_id, presence: true
  validates :type_id, length: { maximum: 5 }
  validates :number_id, presence: true
  validates :number_id, length: { maximum: 50 }
  validates :number_id, uniqueness: {case_sensitive: false, scope: [:type_id, :supplier_state]}, if: :current?
  validates :address, length: { maximum: 255 }
  validates :email, length: { maximum: 25 }
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }
  validates :supplier_state, presence: true
  validates :supplier_state, length: { maximum: 20 }
  validates :supplier_state, inclusion: { in: STATES, message: "%{value} is not a valid supplier_state" }

  def get_state
    self.supplier_state
  end

  def get_state_field
    return :supplier_state
  end

  def change_state state
    self.supplier_state = state
  end

  def count_dependencies
    self.purchases.count
  end
end
