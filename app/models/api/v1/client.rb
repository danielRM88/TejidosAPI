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

class Api::V1::Client < ActiveRecord::Base

  include StateManager

  has_many :invoices
  has_and_belongs_to_many :phones

  scope :current, -> { where(client_state: Stateful::CURRENT_STATE) }

  validates :client_name, presence: true
  validates :client_name, length: { maximum: 50 }
  validates :type_id, presence: true
  validates :type_id, length: { maximum: 5 }
  validates :number_id, presence: true
  validates :number_id, length: { maximum: 50 }
  validates :number_id, uniqueness: {case_sensitive: false, scope: [:type_id, :client_state]}, if: :current?
  validates :address, length: { maximum: 255 }
  validates :email, length: { maximum: 25 }
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }
  validates :client_state, presence: true
  validates :client_state, length: { maximum: 20 }
  validates :client_state, inclusion: { in: STATES, message: "%{value} is not a valid client_state" }

  def get_state
    self.client_state
  end

  def get_state_field
    return :client_state
  end

  def change_state state
    self.client_state = state
  end

  def count_dependencies
    self.invoices.count
  end
end
