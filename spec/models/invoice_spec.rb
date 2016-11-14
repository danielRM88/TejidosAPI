# == Schema Information
#
# Table name: invoices
#
#  id              :integer          not null, primary key
#  client_id       :integer          not null
#  iva_id          :integer          not null
#  invoice_number  :string(50)       not null
#  subtotal        :decimal(18, 2)   not null
#  invoice_date    :date             not null
#  form_of_payment :string(155)      not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  invoice_state   :string(20)       default("CURRENT"), not null
#

require 'rails_helper'

RSpec.describe Invoice, type: :model do
  before(:all) do
    @client = FactoryGirl.create :client
    @iva = FactoryGirl.create :iva
    @fabric = FactoryGirl.create :fabric
    @fabric2 = FactoryGirl.create :fabric2
    @supplier = FactoryGirl.create :supplier
    
    @purchase = Purchase.new
    @purchase.purchase_number = '000001'
    @purchase.supplier = @supplier
    @purchase.iva = @iva
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

  subject { Invoice.new({client: @client, iva: @iva, invoice_number: '000001-a', subtotal: 20.0, invoice_date: Date.new, form_of_payment: "CASH"}) }

  it { should validate_presence_of(:client) }
  it { should validate_presence_of(:iva) }
  it { should validate_presence_of(:invoice_number) }
  it { should validate_uniqueness_of(:invoice_number) }
  it { should validate_length_of(:invoice_number).is_at_most(50) }
  it { should validate_numericality_of(:subtotal) }
  it { should validate_presence_of(:invoice_date) }
  it { should validate_presence_of(:form_of_payment) }
  it { should validate_length_of(:form_of_payment).is_at_most(155) }
  it { should validate_presence_of(:invoice_state) }
  it { should validate_length_of(:invoice_state).is_at_most(20) }
  it { should validate_inclusion_of(:invoice_state).in_array(Stateful::STATES) }

  it 'should have a subtotal equals to the sum of all the sales' do
    invoice = Invoice.new
    invoice.invoice_number = '0000001'
    invoice.client = @client
    invoice.iva = @iva
    invoice.subtotal = 10000
    invoice.invoice_date = Date.new
    invoice.form_of_payment = 'Cash'

    sale1 = Sale.new
    sale1.invoice = invoice
    sale1.inventory = @inventory
    sale1.pieces = 14
    sale1.amount = 10
    sale1.unit = 'meters'
    sale1.unit_price = 300

    sale2 = Sale.new
    sale2.invoice = invoice
    sale2.inventory = @inventory
    sale2.pieces = 3
    sale2.amount = 4
    sale2.unit = 'meters'
    sale2.unit_price = 300

    sale3 = Sale.new
    sale3.invoice = invoice
    sale3.inventory = @inventory4
    sale3.pieces = 17
    sale3.amount = 40
    sale3.unit = 'meters'
    sale3.unit_price = 100

    invoice.sales << sale1
    invoice.sales << sale2
    invoice.sales << sale3
    invoice.save

    subtotal = (sale1.subtotal)+(sale2.subtotal)+(sale3.subtotal)
    expect(invoice.subtotal).to eq(subtotal)
  end

  it "should substract from existence once created" do
    invoice = Invoice.new
    invoice.invoice_number = '0000001'
    invoice.client = @client
    invoice.iva = @iva
    invoice.subtotal = 10000
    invoice.invoice_date = Date.new
    invoice.form_of_payment = 'Cash'

    sale1 = Sale.new
    sale1.invoice = invoice
    sale1.inventory = @inventory
    sale1.pieces = 14
    sale1.amount = 10
    sale1.unit = 'meters'
    sale1.unit_price = 300

    sale2 = Sale.new
    sale2.invoice = invoice
    sale2.inventory = @inventory
    sale2.pieces = 3
    sale2.amount = 4
    sale2.unit = 'meters'
    sale2.unit_price = 300

    sale3 = Sale.new
    sale3.invoice = invoice
    sale3.inventory = @inventory4
    sale3.pieces = 17
    sale3.amount = 40
    sale3.unit = 'meters'
    sale3.unit_price = 100

    sale4 = Sale.new
    sale4.invoice = invoice
    sale4.inventory = @inventory3
    sale4.pieces = 75
    sale4.amount = 50
    sale4.unit = 'meters'
    sale4.unit_price = 100

    invoice.sales << sale1
    invoice.sales << sale2
    invoice.sales << sale3
    invoice.sales << sale4
    invoice.save

    existences = Existence.all
    expect(existences.where(inventory_id: @inventory.id).first.pieces).to eq(@inventory.pieces - sale1.pieces - sale2.pieces)
    expect(existences.where(inventory_id: @inventory4.id).first.pieces).to eq(@inventory.pieces - sale3.pieces)
    expect(existences.where(inventory_id: @inventory3.id).count).to eq(0)
  end

  it "should add to existences when status changed to CANCEL" do
    invoice = Invoice.new
    invoice.invoice_number = '0000001'
    invoice.client = @client
    invoice.iva = @iva
    invoice.subtotal = 10000
    invoice.invoice_date = Date.new
    invoice.form_of_payment = 'Cash'

    sale1 = Sale.new
    sale1.invoice = invoice
    sale1.inventory = @inventory
    sale1.pieces = 14
    sale1.amount = 10
    sale1.unit = 'meters'
    sale1.unit_price = 300

    sale2 = Sale.new
    sale2.invoice = invoice
    sale2.inventory = @inventory
    sale2.pieces = 3
    sale2.amount = 4
    sale2.unit = 'meters'
    sale2.unit_price = 300

    sale3 = Sale.new
    sale3.invoice = invoice
    sale3.inventory = @inventory4
    sale3.pieces = 17
    sale3.amount = 40
    sale3.unit = 'meters'
    sale3.unit_price = 100

    invoice.sales << sale1
    invoice.sales << sale2
    invoice.sales << sale3
    invoice.save!

    existences = Existence.all
    expect(existences.where(inventory_id: @inventory.id).first.pieces).to eq(@inventory.pieces - sale1.pieces - sale2.pieces)
    expect(existences.where(inventory_id: @inventory4.id).first.pieces).to eq(@inventory4.pieces - sale3.pieces)

    invoice.invoice_state = 'CANCEL'
    invoice.save!

    expect(existences.where(inventory_id: @inventory.id).first.pieces).to eq(@inventory.pieces)
    expect(existences.where(inventory_id: @inventory4.id).first.pieces).to eq(@inventory4.pieces)
  end

  it "should substract from existence when status changed to CURRENT" do
    invoice = Invoice.new
    invoice.invoice_number = '0000001'
    invoice.client = @client
    invoice.iva = @iva
    invoice.subtotal = 10000
    invoice.invoice_date = Date.new
    invoice.form_of_payment = 'Cash'

    sale1 = Sale.new
    sale1.invoice = invoice
    sale1.inventory = @inventory
    sale1.pieces = 14
    sale1.amount = 10
    sale1.unit = 'meters'
    sale1.unit_price = 300

    sale2 = Sale.new
    sale2.invoice = invoice
    sale2.inventory = @inventory
    sale2.pieces = 3
    sale2.amount = 4
    sale2.unit = 'meters'
    sale2.unit_price = 300

    sale3 = Sale.new
    sale3.invoice = invoice
    sale3.inventory = @inventory4
    sale3.pieces = 17
    sale3.amount = 40
    sale3.unit = 'meters'
    sale3.unit_price = 100

    sale4 = Sale.new
    sale4.invoice = invoice
    sale4.inventory = @inventory3
    sale4.pieces = 75
    sale4.amount = 50
    sale4.unit = 'meters'
    sale4.unit_price = 100

    invoice.sales << sale1
    invoice.sales << sale2
    invoice.sales << sale3
    invoice.sales << sale4
    invoice.save

    existences = Existence.all
    expect(existences.where(inventory_id: @inventory.id).first.pieces).to eq(@inventory.pieces - sale1.pieces - sale2.pieces)
    expect(existences.where(inventory_id: @inventory4.id).first.pieces).to eq(@inventory.pieces - sale3.pieces)
    expect(existences.where(inventory_id: @inventory3.id).count).to eq(0)

    invoice.invoice_state = 'CANCEL'
    invoice.save!

    expect(existences.where(inventory_id: @inventory.id).first.pieces).to eq(@inventory.pieces)
    expect(existences.where(inventory_id: @inventory4.id).first.pieces).to eq(@inventory4.pieces)

    invoice.invoice_state = 'CURRENT'
    invoice.save!

    expect(existences.where(inventory_id: @inventory.id).first.pieces).to eq(@inventory.pieces - sale1.pieces - sale2.pieces)
    expect(existences.where(inventory_id: @inventory4.id).first.pieces).to eq(@inventory.pieces - sale3.pieces)
    expect(existences.where(inventory_id: @inventory3.id).count).to eq(0)
  end

  it "should add to existences when deleted" do
    invoice = Invoice.new
    invoice.invoice_number = '0000001'
    invoice.client = @client
    invoice.iva = @iva
    invoice.subtotal = 10000
    invoice.invoice_date = Date.new
    invoice.form_of_payment = 'Cash'

    sale1 = Sale.new
    sale1.invoice = invoice
    sale1.inventory = @inventory
    sale1.pieces = 14
    sale1.amount = 10
    sale1.unit = 'meters'
    sale1.unit_price = 300

    sale2 = Sale.new
    sale2.invoice = invoice
    sale2.inventory = @inventory
    sale2.pieces = 3
    sale2.amount = 4
    sale2.unit = 'meters'
    sale2.unit_price = 300

    sale3 = Sale.new
    sale3.invoice = invoice
    sale3.inventory = @inventory4
    sale3.pieces = 17
    sale3.amount = 40
    sale3.unit = 'meters'
    sale3.unit_price = 100

    invoice.sales << sale1
    invoice.sales << sale2
    invoice.sales << sale3
    invoice.save!

    existences = Existence.all
    expect(existences.where(inventory_id: @inventory.id).first.pieces).to eq(@inventory.pieces - sale1.pieces - sale2.pieces)
    expect(existences.where(inventory_id: @inventory4.id).first.pieces).to eq(@inventory4.pieces - sale3.pieces)

    invoice.destroy!

    expect(existences.where(inventory_id: @inventory.id).first.pieces).to eq(@inventory.pieces)
    expect(existences.where(inventory_id: @inventory4.id).first.pieces).to eq(@inventory4.pieces)
  end

  it "should raise an exception for any inconsistency between pieces and amount (one zero other not)" do
    invoice = Invoice.new
    invoice.invoice_number = '0000001'
    invoice.client = @client
    invoice.iva = @iva
    invoice.subtotal = 10000
    invoice.invoice_date = Date.new
    invoice.form_of_payment = 'Cash'

    sale1 = Sale.new
    sale1.invoice = invoice
    sale1.inventory = @inventory
    sale1.pieces = 14
    sale1.amount = 10
    sale1.unit = 'meters'
    sale1.unit_price = 300

    sale2 = Sale.new
    sale2.invoice = invoice
    sale2.inventory = @inventory
    sale2.pieces = 3
    sale2.amount = 4
    sale2.unit = 'meters'
    sale2.unit_price = 300

    sale3 = Sale.new
    sale3.invoice = invoice
    sale3.inventory = @inventory4
    sale3.pieces = 17
    sale3.amount = 40
    sale3.unit = 'meters'
    sale3.unit_price = 100

    sale4 = Sale.new
    sale4.invoice = invoice
    sale4.inventory = @inventory3
    sale4.pieces = 75
    sale4.amount = 40
    sale4.unit = 'meters'
    sale4.unit_price = 100

    invoice.sales << sale1
    invoice.sales << sale2
    invoice.sales << sale3
    invoice.sales << sale4
    expect {invoice.save!}.to raise_exception(ActiveRecord::StatementInvalid)
  end

  it "should raise an exception if there is not enough amount" do
    invoice = Invoice.new
    invoice.invoice_number = '0000001'
    invoice.client = @client
    invoice.iva = @iva
    invoice.subtotal = 10000
    invoice.invoice_date = Date.new
    invoice.form_of_payment = 'Cash'

    sale1 = Sale.new
    sale1.invoice = invoice
    sale1.inventory = @inventory
    sale1.pieces = 14
    sale1.amount = 10
    sale1.unit = 'meters'
    sale1.unit_price = 300

    sale2 = Sale.new
    sale2.invoice = invoice
    sale2.inventory = @inventory
    sale2.pieces = 3
    sale2.amount = 4
    sale2.unit = 'meters'
    sale2.unit_price = 300

    sale3 = Sale.new
    sale3.invoice = invoice
    sale3.inventory = @inventory4
    sale3.pieces = 17
    sale3.amount = 40
    sale3.unit = 'meters'
    sale3.unit_price = 100

    sale4 = Sale.new
    sale4.invoice = invoice
    sale4.inventory = @inventory3
    sale4.pieces = 75
    sale4.amount = 60
    sale4.unit = 'meters'
    sale4.unit_price = 100

    invoice.sales << sale1
    invoice.sales << sale2
    invoice.sales << sale3
    invoice.sales << sale4
    expect {invoice.save!}.to raise_exception(ActiveRecord::StatementInvalid)
  end

  it "should raise an exception if there is not enough pieces" do
    invoice = Invoice.new
    invoice.invoice_number = '0000001'
    invoice.client = @client
    invoice.iva = @iva
    invoice.subtotal = 10000
    invoice.invoice_date = Date.new
    invoice.form_of_payment = 'Cash'

    sale1 = Sale.new
    sale1.invoice = invoice
    sale1.inventory = @inventory
    sale1.pieces = 14
    sale1.amount = 10
    sale1.unit = 'meters'
    sale1.unit_price = 300

    sale2 = Sale.new
    sale2.invoice = invoice
    sale2.inventory = @inventory
    sale2.pieces = 3
    sale2.amount = 4
    sale2.unit = 'meters'
    sale2.unit_price = 300

    sale3 = Sale.new
    sale3.invoice = invoice
    sale3.inventory = @inventory4
    sale3.pieces = 17
    sale3.amount = 40
    sale3.unit = 'meters'
    sale3.unit_price = 100

    sale4 = Sale.new
    sale4.invoice = invoice
    sale4.inventory = @inventory3
    sale4.pieces = 85
    sale4.amount = 40
    sale4.unit = 'meters'
    sale4.unit_price = 100

    invoice.sales << sale1
    invoice.sales << sale2
    invoice.sales << sale3
    invoice.sales << sale4
    expect {invoice.save!}.to raise_exception(ActiveRecord::StatementInvalid)
  end
end
