# == Schema Information
#
# Table name: purchases
#
#  id              :integer          not null, primary key
#  supplier_id     :integer          not null
#  vat             :decimal(6, 2)    not null
#  purchase_number :string(50)       not null
#  subtotal        :decimal(18, 2)   not null
#  form_of_payment :string(155)      not null
#  purchase_date   :date             not null
#  purchase_state  :string(20)       default("CURRENT"), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Api::V1::Purchase < ActiveRecord::Base

  include Stateful

  belongs_to :supplier
  # belongs_to :iva
  has_many :inventories, inverse_of: :purchase

  validates :supplier, presence: true
  # validates :iva, presence: true
  validates :vat, presence: true
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

  accepts_nested_attributes_for :inventories

  def current?
    self.purchase_state == CURRENT_STATE
  end

  def subtotal
    subtotal = 0

    inventories.each do |inventory|
      subtotal += inventory.subtotal
    end

    self[:subtotal] = subtotal if self[:subtotal].blank?
    return subtotal
  end

  def as_json(options = { })
    json = super(options)
    json[:supplier_data] = supplier_data
    json
  end

  def supplier_data
    return {
      supplier_type_id: self.supplier.type_id, 
      supplier_number_id: self.supplier.number_id, 
      supplier_name: self.supplier.supplier_name
    }
  end
end
