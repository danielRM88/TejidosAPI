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

require 'rails_helper'

module Api::V1
    RSpec.describe Purchase, type: :model do
      before(:all) do
        @client = FactoryGirl.create :client2
        # @vat = FactoryGirl.create :vat3
        @vat = 13
        @supplier = FactoryGirl.create :supplier3
        @fabric = FactoryGirl.create :fabric3
        @fabric2 = FactoryGirl.create :fabric4
      end

      subject { 
        purchase = Purchase.new(supplier: @supplier, vat: @vat, purchase_number: "0000001q", subtotal: 10000, form_of_payment: "CASH", purchase_date: Date.new)
        inventory1 = Inventory.new(purchase: purchase, fabric: @fabric, pieces: 10, amount: 5, unit: 'kg', unit_price: 50)
        inventory2 = Inventory.new(purchase: purchase, fabric: @fabric2, pieces: 50, amount: 15, unit: 'kg', unit_price: 100)
        purchase.inventories << inventory1
        purchase.inventories << inventory2
        purchase.save

        return purchase
        # FactoryGirl.create :purchase2, vat: 13.98, supplier: @supplier 
      }

      it { should validate_presence_of(:supplier) }
      it { should validate_presence_of(:vat) }
      it { should validate_presence_of(:purchase_number) }
      it { should validate_length_of(:purchase_number).is_at_most(50) }
      it { should validate_uniqueness_of(:purchase_number).case_insensitive.scoped_to([:supplier_id, :purchase_state]) }
      it { should validate_numericality_of(:subtotal) }
      it { should validate_presence_of(:form_of_payment) }
      it { should validate_length_of(:form_of_payment).is_at_most(155) }
      it { should validate_presence_of(:purchase_date) }
      it { should validate_presence_of(:purchase_state) }
      it { should validate_length_of(:purchase_state).is_at_most(20) }
      it { should validate_inclusion_of(:purchase_state).in_array(Stateful::STATES) }

      it "should have a subtotal equals to the sum of all inventories" do
        purchase = Purchase.new(supplier: @supplier, vat: @vat, purchase_number: "0000001q", subtotal: 10000, form_of_payment: "CASH", purchase_date: Date.new)
        inventory1 = Inventory.create(purchase: purchase, fabric: @fabric, pieces: 10, amount: 5, unit: 'kg', unit_price: 50)
        inventory2 = Inventory.create(purchase: purchase, fabric: @fabric2, pieces: 50, amount: 15, unit: 'kg', unit_price: 100)
        purchase.inventories << inventory1
        purchase.inventories << inventory2

        subtotal = inventory1.subtotal+inventory2.subtotal
        expect(purchase.subtotal).to eq(subtotal)
      end

      it "should add to existences when created" do
        purchase = Purchase.new(supplier: @supplier, vat: @vat, purchase_number: "0000001w", subtotal: 10000, form_of_payment: "CASH", purchase_date: Date.new)
        inventory1 = Inventory.create(purchase: purchase, fabric: @fabric, pieces: 10, amount: 5, unit: 'kg', unit_price: 50)
        inventory2 = Inventory.create(purchase: purchase, fabric: @fabric2, pieces: 50, amount: 15, unit: 'kg', unit_price: 100)
        purchase.inventories << inventory1
        purchase.inventories << inventory2
        purchase.save

        existence1 = Existence.where(inventory_id: inventory1.id).first
        existence2 = Existence.where(inventory_id: inventory2.id).first

        expect(existence1.pieces).to eq(inventory1.pieces)
        expect(existence1.amount).to eq(inventory1.amount)

        expect(existence2.pieces).to eq(inventory2.pieces)
        expect(existence2.amount).to eq(inventory2.amount)

        inventory3 = Inventory.create(purchase: purchase, fabric: @fabric, pieces: 5, amount: 2.5, unit: 'kg', unit_price: 50)
        purchase.inventories << inventory3
        purchase.save

        existence3 = Existence.where(inventory_id: inventory3.id).first
        expect(existence3.pieces).to eq(inventory3.pieces)
        expect(existence3.amount).to eq(inventory3.amount)
      end

      it "should add to existences when status changed to CURRENT" do
        purchase = Purchase.new(supplier: @supplier, vat: @vat, purchase_number: "0000001e", subtotal: 10000, form_of_payment: "CASH", purchase_date: Date.new)
        inventory1 = Inventory.create(purchase: purchase, fabric: @fabric, pieces: 10, amount: 5, unit: 'kg', unit_price: 50)
        inventory2 = Inventory.create(purchase: purchase, fabric: @fabric2, pieces: 50, amount: 15, unit: 'kg', unit_price: 100)
        purchase.inventories << inventory1
        purchase.inventories << inventory2
        purchase.save

        existence1 = Existence.where(inventory_id: inventory1.id).first
        existence2 = Existence.where(inventory_id: inventory2.id).first

        expect(existence1.pieces).to eq(inventory1.pieces)
        expect(existence1.amount).to eq(inventory1.amount)

        expect(existence2.pieces).to eq(inventory2.pieces)
        expect(existence2.amount).to eq(inventory2.amount)

        purchase.purchase_state = Stateful::CANCEL_STATE
        purchase.save

        existence1 = Existence.where(inventory_id: inventory1.id).first
        existence2 = Existence.where(inventory_id: inventory2.id).first

        expect(existence1).to be_nil
        expect(existence2).to be_nil

        purchase.purchase_state = Stateful::CURRENT_STATE
        purchase.save

        existence1 = Existence.where(inventory_id: inventory1.id).first
        existence2 = Existence.where(inventory_id: inventory2.id).first

        expect(existence1.pieces).to eq(inventory1.pieces)
        expect(existence1.amount).to eq(inventory1.amount)

        expect(existence2.pieces).to eq(inventory2.pieces)
        expect(existence2.amount).to eq(inventory2.amount)
      end

      it "should substract from existences when status changed to CANCEL" do
        purchase = Purchase.new(supplier: @supplier, vat: @vat, purchase_number: "0000001r", subtotal: 10000, form_of_payment: "CASH", purchase_date: Date.new)
        inventory1 = Inventory.create(purchase: purchase, fabric: @fabric, pieces: 10, amount: 5, unit: 'kg', unit_price: 50)
        inventory2 = Inventory.create(purchase: purchase, fabric: @fabric2, pieces: 50, amount: 15, unit: 'kg', unit_price: 100)
        purchase.inventories << inventory1
        purchase.inventories << inventory2
        purchase.save

        existence1 = Existence.where(inventory_id: inventory1.id).first
        existence2 = Existence.where(inventory_id: inventory2.id).first

        expect(existence1.pieces).to eq(inventory1.pieces)
        expect(existence1.amount).to eq(inventory1.amount)

        expect(existence2.pieces).to eq(inventory2.pieces)
        expect(existence2.amount).to eq(inventory2.amount)

        purchase.purchase_state = Stateful::CANCEL_STATE
        purchase.save

        existence1 = Existence.where(inventory_id: inventory1.id).first
        existence2 = Existence.where(inventory_id: inventory2.id).first

        expect(existence1).to be_nil
        expect(existence2).to be_nil
      end

      it "should substract from existences when deleted" do
        purchase = Purchase.new(supplier: @supplier, vat: @vat, purchase_number: "0000001t", subtotal: 10000, form_of_payment: "CASH", purchase_date: Date.new)
        inventory1 = Inventory.create(purchase: purchase, fabric: @fabric, pieces: 10, amount: 5, unit: 'kg', unit_price: 50)
        inventory2 = Inventory.create(purchase: purchase, fabric: @fabric2, pieces: 50, amount: 15, unit: 'kg', unit_price: 100)
        purchase.inventories << inventory1
        purchase.inventories << inventory2
        purchase.save

        existence1 = Existence.where(inventory_id: inventory1.id).first
        existence2 = Existence.where(inventory_id: inventory2.id).first

        expect(existence1.pieces).to eq(inventory1.pieces)
        expect(existence1.amount).to eq(inventory1.amount)

        expect(existence2.pieces).to eq(inventory2.pieces)
        expect(existence2.amount).to eq(inventory2.amount)

        purchase.destroy

        existence1 = Existence.where(inventory_id: inventory1.id).first
        existence2 = Existence.where(inventory_id: inventory2.id).first

        expect(existence1).to be_nil
        expect(existence2).to be_nil
      end

      it "should raise an exception if there is not enough existence to delete a purchase" do
        purchase = Purchase.new(supplier: @supplier, vat: @vat, purchase_number: "80m", subtotal: 10000, form_of_payment: "CASH", purchase_date: Date.new)
        inventory1 = Inventory.create(purchase: purchase, fabric: @fabric, pieces: 10, amount: 5, unit: 'kg', unit_price: 50)
        inventory2 = Inventory.create(purchase: purchase, fabric: @fabric2, pieces: 50, amount: 15, unit: 'kg', unit_price: 100)
        purchase.inventories << inventory1
        purchase.inventories << inventory2
        purchase.save

        invoice = Invoice.new(client: FactoryGirl.create(:client4), vat: @vat, invoice_number: '00000198p', subtotal: 10000, invoice_date: Date.new, form_of_payment: "CASH")
        sale1 = Sale.create(invoice: invoice, inventory: inventory1, pieces: 4, amount: 1, unit: 'kg', unit_price: 65)
        sale2 = Sale.create(invoice: invoice, inventory: inventory2, pieces: 25, amount: 10, unit: 'kg', unit_price: 120)

        invoice.sales << sale1
        invoice.sales << sale2
        invoice.save

        expect { purchase.destroy }.to raise_exception(ActiveRecord::StatementInvalid)
      end

      it "should raise an exception if there is not enough existence to CANCEL a purchase" do
        purchase = Purchase.new(supplier: @supplier, vat: @vat, purchase_number: "0000001i", subtotal: 10000, form_of_payment: "CASH", purchase_date: Date.new)
        inventory1 = Inventory.create(purchase: purchase, fabric: @fabric, pieces: 10, amount: 5, unit: 'kg', unit_price: 50)
        inventory2 = Inventory.create(purchase: purchase, fabric: @fabric2, pieces: 50, amount: 15, unit: 'kg', unit_price: 100)
        purchase.inventories << inventory1
        purchase.inventories << inventory2
        purchase.save

        invoice = Invoice.new(client: FactoryGirl.create(:client3), vat: @vat, invoice_number: '000001-o', subtotal: 10000, invoice_date: Date.new, form_of_payment: "CASH")
        sale1 = Sale.create(invoice: invoice, inventory: inventory1, pieces: 4, amount: 1, unit: 'kg', unit_price: 65)
        sale2 = Sale.create(invoice: invoice, inventory: inventory2, pieces: 25, amount: 10, unit: 'kg', unit_price: 120)

        invoice.sales << sale1
        invoice.sales << sale2
        invoice.save

        expect { purchase.update(purchase_state: Stateful::CANCEL_STATE) }.to raise_exception(ActiveRecord::StatementInvalid)
      end
    end
end
