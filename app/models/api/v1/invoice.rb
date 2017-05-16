# == Schema Information
#
# Table name: invoices
#
#  id              :integer          not null, primary key
#  client_id       :integer          not null
#  vat             :decimal(6, 2)    not null
#  invoice_number  :string(50)       not null
#  subtotal        :decimal(18, 2)   not null
#  invoice_date    :date             not null
#  form_of_payment :string(155)      not null
#  invoice_state   :string(20)       default("CURRENT"), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class Api::V1::Invoice < ActiveRecord::Base
  include Stateful

  belongs_to :client
  # belongs_to :iva
  has_many :sales

  validates :client, presence: true
  # validates :iva, presence: true
  validates :vat, presence: true
  validates :invoice_number, presence: true
  validates :invoice_number, length: { maximum: 50 }
  validates :invoice_number, uniqueness: true
  validates :subtotal, numericality: { greater_than: 0 }
  validates :invoice_date, presence: true
  validates :form_of_payment, presence: true
  validates :form_of_payment, length: { maximum: 155 }
  validates :invoice_state, presence: true
  validates :invoice_state, length: { maximum: 20 }
  validates :invoice_state, inclusion: { in: STATES, message: "%{value} is not a valid invoice_state" }

  def subtotal
    subtotal = 0

    sales.each do |sale|
      subtotal += sale.subtotal
    end

    return subtotal
  end

end
