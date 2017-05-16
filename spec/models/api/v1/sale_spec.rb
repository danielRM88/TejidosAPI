# == Schema Information
#
# Table name: sales
#
#  id           :integer          not null, primary key
#  invoice_id   :integer          not null
#  inventory_id :integer          not null
#  pieces       :integer          not null
#  amount       :decimal(10, 2)   not null
#  unit         :string(15)       not null
#  unit_price   :decimal(18, 2)   not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'rails_helper'

module Api::V1
    RSpec.describe Sale, type: :model do
      before(:all) do
        @client = FactoryGirl.create :client4
        # @vat = FactoryGirl.create :vat5
        @vat = 12
        @fabric = FactoryGirl.create :fabric6
        @fabric2 = FactoryGirl.create :fabric7
        @supplier = FactoryGirl.create :supplier5
        
        @purchase = Purchase.new
        @purchase.purchase_number = '000001'
        @purchase.supplier = @supplier
        @purchase.vat = @vat
        @purchase.subtotal = 750
        @purchase.form_of_payment = 'Cash'
        @purchase.purchase_date = Date.new

        @inventory = Inventory.new
        @inventory.purchase = @purchase
        @inventory.fabric = @fabric
        @inventory.pieces = 20
        @inventory.amount = 15
        @inventory.unit = 'meters'
        @inventory.unit_price = 250

        @inventory2 = Inventory.new
        @inventory2.purchase = @purchase
        @inventory2.fabric = @fabric2
        @inventory2.pieces = 10
        @inventory2.amount = 5
        @inventory2.unit = 'meters'
        @inventory2.unit_price = 500

        @inventory3 = Inventory.new
        @inventory3.purchase = @purchase
        @inventory3.fabric = @fabric2
        @inventory3.pieces = 75
        @inventory3.amount = 50
        @inventory3.unit = 'meters'
        @inventory3.unit_price = 100

        @inventory4 = Inventory.new
        @inventory4.purchase = @purchase
        @inventory4.fabric = @fabric2
        @inventory4.pieces = 20
        @inventory4.amount = 46
        @inventory4.unit = 'meters'
        @inventory4.unit_price = 40

        @purchase.inventories << @inventory
        @purchase.inventories << @inventory2
        @purchase.inventories << @inventory3
        @purchase.inventories << @inventory4
        @purchase.save
      end

      subject { Sale.create(invoice: FactoryGirl.create(:invoice, vat: @vat, client: @client), inventory: @inventory2, pieces: 7, amount: 2, unit: 'kg', unit_price: 150) }

      it { should validate_presence_of(:invoice) }
      it { should validate_presence_of(:inventory) }
      it { should validate_presence_of(:pieces) }
      it { should validate_numericality_of(:pieces).only_integer }
      it { should validate_presence_of(:amount) }
      it { should validate_numericality_of(:amount) }
      it { should validate_presence_of(:unit) }
      it { should validate_length_of(:unit).is_at_most(15) }
      it { should validate_presence_of(:unit_price) }
      it { should validate_numericality_of(:unit_price) }

      it "should have a subtotal equals to the pieces * unit_price" do
        sale = Sale.create(invoice: FactoryGirl.create(:invoice, vat: @vat, client: @client), inventory: @inventory2, pieces: 7, amount: 2, unit: 'kg', unit_price: 150)

        expect(sale.subtotal).to eq((sale.pieces*sale.unit_price))
      end

      it "should remove from existence after created" do
        sale = Sale.create(invoice: FactoryGirl.create(:invoice, vat: @vat, client: @client), inventory: @inventory2, pieces: 7, amount: 2, unit: 'kg', unit_price: 150)
        existence = Existence.where(inventory_id: @inventory2.id).first

        expect(existence.pieces).to eq(@inventory2.pieces - sale.pieces)
        expect(existence.amount).to eq(@inventory2.amount - sale.amount)
      end

      it "should raise an exception for any inconsistency between pieces and amount (one zero other not)" do
        invoice = Invoice.new
        invoice.invoice_number = '0000001'
        invoice.client = @client
        invoice.vat = @vat
        invoice.subtotal = 10000
        invoice.invoice_date = Date.new
        invoice.form_of_payment = 'Cash'

        sale3 = Sale.new
        sale3.invoice = invoice
        sale3.inventory = @inventory4
        sale3.pieces = 20
        sale3.amount = 41
        sale3.unit = 'meters'
        sale3.unit_price = 100

        expect {sale3.save!}.to raise_exception(ActiveRecord::StatementInvalid)
      end

      it "should raise an exception if there is not enough amount" do
        invoice = Invoice.new
        invoice.invoice_number = '0000001'
        invoice.client = @client
        invoice.vat = @vat
        invoice.subtotal = 10000
        invoice.invoice_date = Date.new
        invoice.form_of_payment = 'Cash'

        sale1 = Sale.new
        sale1.invoice = invoice
        sale1.inventory = @inventory
        sale1.pieces = 14
        sale1.amount = 17
        sale1.unit = 'meters'
        sale1.unit_price = 300

        expect {sale1.save!}.to raise_exception(ActiveRecord::StatementInvalid)
      end

      it "should raise an exception if there is not enough pieces" do
        invoice = Invoice.new
        invoice.invoice_number = '0000001'
        invoice.client = @client
        invoice.vat = @vat
        invoice.subtotal = 10000
        invoice.invoice_date = Date.new
        invoice.form_of_payment = 'Cash'

        sale1 = Sale.new
        sale1.invoice = invoice
        sale1.inventory = @inventory
        sale1.pieces = 22
        sale1.amount = 10
        sale1.unit = 'meters'
        sale1.unit_price = 300
        
        expect {sale1.save!}.to raise_exception(ActiveRecord::StatementInvalid)
      end
    end
end