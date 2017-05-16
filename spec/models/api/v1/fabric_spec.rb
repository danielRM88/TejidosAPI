# == Schema Information
#
# Table name: fabrics
#
#  id           :integer          not null, primary key
#  code         :string(20)       not null
#  description  :string(255)      not null
#  color        :string(50)       not null
#  unit_price   :decimal(18, 2)   not null
#  fabric_state :string(20)       default("CURRENT"), not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'rails_helper'

module Api::V1
  RSpec.describe Fabric, type: :model do
    subject { FactoryGirl.create :fabric }

    it { should validate_presence_of(:code) }
    it { should validate_length_of(:code).is_at_most(20) }
    it { should validate_uniqueness_of(:code).case_insensitive.scoped_to(:fabric_state) }
    it { should validate_length_of(:description).is_at_most(255) }
    it { should validate_length_of(:color).is_at_most(50) }
    it { should validate_presence_of(:unit_price) }
    it { should validate_numericality_of(:unit_price).is_greater_than(0) }
    it { should validate_presence_of(:fabric_state) }
    it { should validate_length_of(:fabric_state).is_at_most(20) }
    it { should validate_inclusion_of(:fabric_state).in_array(Stateful::STATES) }

    it "should create new record when updated if it has dependencies" do
      fabric = FactoryGirl.create :fabric2
      
      # vat = FactoryGirl.create :vat3
      vat = 13
      supplier = FactoryGirl.create :supplier3
      purchase = Purchase.new(supplier: supplier, vat: vat, purchase_number: "0000001q", subtotal: 10000, form_of_payment: "CASH", purchase_date: Date.new)
      inventory1 = Inventory.new(purchase: purchase, fabric: fabric, pieces: 10, amount: 5, unit: 'kg', unit_price: 50)
      purchase.inventories << inventory1
      purchase.save

      fabric.description = "New Description"
      fabric.save

      expect(fabric.fabric_state).to eq(Stateful::UPDATED_STATE)

      new_fabric = Fabric.where(code: fabric.code,
                                color: fabric.color,
                                unit_price: fabric.unit_price,
                                fabric_state: Stateful::CURRENT_STATE).first

      expect(new_fabric).not_to be_nil
    end

    it "should update status when deleted if it has dependencies" do
      fabric = FactoryGirl.create :fabric3

      # vat = FactoryGirl.create :vat2
      vat = 12
      supplier = FactoryGirl.create :supplier2
      purchase = Purchase.new(supplier: supplier, vat: vat, purchase_number: "0000001q", subtotal: 10000, form_of_payment: "CASH", purchase_date: Date.new)
      inventory1 = Inventory.new(purchase: purchase, fabric: fabric, pieces: 10, amount: 5, unit: 'kg', unit_price: 50)
      purchase.inventories << inventory1
      purchase.save

      fabric.destroy
      expect(fabric.fabric_state).to eq(Stateful::DELETED_STATE)
    end
  end
end
