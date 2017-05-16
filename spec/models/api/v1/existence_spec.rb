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

require 'rails_helper'

module Api::V1
  RSpec.describe Existence, type: :model do
    before(:all) do
      # @vat = FactoryGirl.create :vat6
      @fabric = FactoryGirl.create :fabric8
      @supplier = FactoryGirl.create :supplier6

      purchase = Purchase.new(supplier: @supplier, vat: 12, purchase_number: "0000001q", subtotal: 10000, form_of_payment: "CASH", purchase_date: Date.new)
      @inventory = Inventory.new(purchase: purchase, fabric: @fabric, pieces: 10, amount: 5, unit: 'kg', unit_price: 50)
      purchase.inventories << @inventory
      purchase.save

      # @inventory = Inventory.create(purchase: FactoryGirl.create(:purchase, supplier: @supplier, vat: 12), fabric: @fabric, pieces: 100, amount: 50, unit: 'kg', unit_price: 150)
    end

    subject { Existence.where(inventory_id: @inventory.id).first }

    it { should validate_presence_of(:inventory) }
    it { should validate_presence_of(:pieces) }
    it { should validate_numericality_of(:pieces).only_integer.is_greater_than(0) }
    it { should validate_presence_of(:amount) }
    it { should validate_numericality_of(:amount) }
    it { should validate_presence_of(:unit) }
    it { should validate_length_of(:unit).is_at_most(15) }
  end
end