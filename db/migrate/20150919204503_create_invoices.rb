class CreateInvoices < ActiveRecord::Migration
  def change
    create_table :invoices do |t|
      t.references :client, null: false, index: true
      # t.references :iva, null: false, index: true
      t.decimal :vat, precision: 6, scale: 2, null: false
      t.string :invoice_number, limit: 50, null: false
      t.decimal :subtotal, precision: 18, scale: 2, null: false
      t.date :invoice_date, null: false
      t.string :form_of_payment, limit: 155, null: false
      t.string :invoice_state, limit: 20, null: false, default: 'CURRENT'
      t.timestamps null: false
    end
    add_foreign_key :invoices, :clients, name: "INVOICES_CLIENTS_FK"
    # add_foreign_key :invoices, :ivas, name: "INVOICES_IVAS_FK"
    add_index(:invoices, [:invoice_number], unique: true, name: "INVOICES_UNIQUE_NUMBER")
  end
end
