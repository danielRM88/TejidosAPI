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

require 'rails_helper'

module Api::V1
  RSpec.describe Inventory, type: :model do
    before(:all) do
      # @vat = FactoryGirl.create :vat4
      @vat = 12
      @fabric = FactoryGirl.create :fabric5
      @supplier = FactoryGirl.create :supplier4
    end

    subject { 
      purchase = Purchase.new(supplier: @supplier, vat: @vat, purchase_number: "0000001b", subtotal: 10000, form_of_payment: "CASH", purchase_date: Date.new)
      @inventory = Inventory.new(purchase: purchase, fabric: @fabric, pieces: 10, amount: 5, unit: 'kg', unit_price: 50)
      # inventory2 = Inventory.create(purchase: purchase, fabric: @fabric2, pieces: 50, amount: 15, unit: 'kg', unit_price: 100)
      purchase.inventories << @inventory
      purchase.save
      # purchase.inventories << inventory2
      Inventory.create(purchase: purchase, fabric: @fabric, pieces: 100, amount: 50, unit: 'kg', unit_price: 150) 
    }

    it { should validate_presence_of(:purchase) }
    it { should validate_presence_of(:fabric) }
    it { should validate_presence_of(:pieces) }
    it { should validate_numericality_of(:pieces).only_integer.is_greater_than(0) }
    it { should validate_presence_of(:amount) }
    it { should validate_numericality_of(:amount) }
    it { should validate_presence_of(:unit) }
    it { should validate_length_of(:unit).is_at_most(15) }
    it { should validate_presence_of(:unit_price) }
    it { should validate_numericality_of(:unit_price) }

    it "should have a subtotal equals to the amount * unit_price" do
      # inventory = Inventory.create(purchase: FactoryGirl.create(:purchase, supplier: @supplier, vat: @vat), fabric: @fabric, pieces: 100, amount: 50, unit: 'kg', unit_price: 150)
      purchase = Purchase.new(supplier: @supplier, vat: @vat, purchase_number: "0000001b", subtotal: 10000, form_of_payment: "CASH", purchase_date: Date.new)
      inventory = Inventory.new(purchase: purchase, fabric: @fabric, pieces: 10, amount: 5, unit: 'kg', unit_price: 50)
      # inventory2 = Inventory.create(purchase: purchase, fabric: @fabric2, pieces: 50, amount: 15, unit: 'kg', unit_price: 100)
      purchase.inventories << inventory
      purchase.save

      expect(inventory.subtotal).to eq((inventory.amount*inventory.unit_price))
    end

    it "should insert into existence after created" do
      purchase = Purchase.new(supplier: @supplier, vat: @vat, purchase_number: "0000001b", subtotal: 10000, form_of_payment: "CASH", purchase_date: Date.new)
      inventory = Inventory.new(purchase: purchase, fabric: @fabric, pieces: 10, amount: 5, unit: 'kg', unit_price: 50)
      # inventory2 = Inventory.create(purchase: purchase, fabric: @fabric2, pieces: 50, amount: 15, unit: 'kg', unit_price: 100)
      purchase.inventories << inventory
      purchase.save
      # inventory = Inventory.create(purchase: FactoryGirl.create(:purchase, supplier: @supplier, vat: @vat), fabric: @fabric, pieces: 100, amount: 50, unit: 'kg', unit_price: 150)
      existence = Existence.where(inventory_id: inventory.id).first

      expect(existence).not_to be_nil
    end
  end
end