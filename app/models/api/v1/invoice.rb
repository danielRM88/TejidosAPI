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
  has_many :sales, inverse_of: :invoice

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

  accepts_nested_attributes_for :sales

  def subtotal
    subtotal = 0

    sales.each do |sale|
      subtotal += sale.subtotal
    end

    self[:subtotal] = subtotal if self[:subtotal].blank?
    return subtotal
  end

  def pick_sales sales_hash
    sales_hash.each do |sale|
      fabric_id = sale["fabric_id"]
      amount_needed = sale["amount"].to_f
      pieces_needed = sale["pieces"].to_i
      unit = sale["unit"]
      unit_price = sale["unit_price"]

      Api::V1::Existence.enough_existence fabric_id, amount_needed, pieces_needed, unit

      existences = Api::V1::Existence.less_amount_and_pieces_with_fabric_id(fabric_id, unit)
      sale = nil
      sale_amount = 0
      sale_pieces = 0
      existences.each do |e|
        # byebug
        sale_amount = (e.amount > amount_needed ? amount_needed : e.amount)
        sale_pieces = (e.pieces > pieces_needed ? pieces_needed : e.pieces)
        sale = Api::V1::Sale.new(inventory_id: e.inventory_id, pieces: sale_pieces, amount: sale_amount, unit: e.unit, unit_price: unit_price)

        amount_needed -= sale_amount
        pieces_needed -= sale_pieces

        self.sales << sale
        break if (amount_needed == 0 && pieces_needed == 0)
      end
    end

  end

  def as_json(options = { })
    json = super(options)
    json[:client_data] = client_data
    json
  end

  def client_data
    return {
      client_type_id: self.client.type_id, 
      client_number_id: self.client.number_id, 
      client_name: self.client.client_name
    }
  end

end
