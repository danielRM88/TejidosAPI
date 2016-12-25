# == Schema Information
#
# Table name: purchases
#
#  id              :integer          not null, primary key
#  supplier_id     :integer          not null
#  iva_id          :integer          not null
#  purchase_number :string(50)       not null
#  subtotal        :decimal(18, 2)   not null
#  form_of_payment :string(155)
#  purchase_date   :date             not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  purchase_state  :string(20)       default("CURRENT"), not null
#

class Api::V1::Purchase < ActiveRecord::Base

  include Stateful

  belongs_to :supplier
  belongs_to :iva
  has_many :inventories

  validates :supplier, presence: true
  validates :iva, presence: true
  validates :purchase_number, presence: true
  validates :purchase_number, length: { maximum: 50 }
  validates :purchase_number, uniqueness: {case_sensitive: false, scope: [:supplier_id, :purchase_state]}, if: :current?
  validates :subtotal, numericality: { greater_than: 0 }
  validates :purchase_date, presence: true
  validates :form_of_payment, presence: true
  validates :form_of_payment, length: { maximum: 155 }
  validates :purchase_state, presence: true
  validates :purchase_state, length: { maximum: 20 }
  validates :purchase_state, inclusion: { in: STATES, message: "%{value} is not a valid invoice_state" }

  def current?
    self.purchase_state == CURRENT_STATE
  end

  def subtotal
    subtotal = 0

    inventories.each do |inventory|
      subtotal += inventory.subtotal
    end

    return subtotal
  end
end
