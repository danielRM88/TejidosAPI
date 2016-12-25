# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20151017233254) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "clients", force: :cascade do |t|
    t.string   "client_name",  limit: 50,                      null: false
    t.string   "type_id",      limit: 5,                       null: false
    t.string   "number_id",    limit: 50,                      null: false
    t.string   "address",      limit: 255
    t.string   "email",        limit: 25
    t.string   "client_state", limit: 20,  default: "CURRENT", null: false
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
  end

  add_index "clients", ["type_id", "number_id"], name: "CLIENTS_UNIQUE_ID", unique: true, where: "((client_state)::text = 'CURRENT'::text)", using: :btree

  create_table "clients_phones", force: :cascade do |t|
    t.integer  "phone_id",   null: false
    t.integer  "client_id",  null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "clients_phones", ["client_id"], name: "index_clients_phones_on_client_id", using: :btree
  add_index "clients_phones", ["phone_id"], name: "index_clients_phones_on_phone_id", using: :btree

  create_table "existences", force: :cascade do |t|
    t.integer  "inventory_id",                                     null: false
    t.integer  "pieces",                                           null: false
    t.decimal  "amount",                  precision: 10, scale: 2, null: false
    t.string   "unit",         limit: 15,                          null: false
    t.datetime "created_at",                                       null: false
    t.datetime "updated_at",                                       null: false
  end

  add_index "existences", ["inventory_id"], name: "EXISTENCES_UNIQUE_INV", unique: true, using: :btree
  add_index "existences", ["inventory_id"], name: "index_existences_on_inventory_id", using: :btree

  create_table "fabrics", force: :cascade do |t|
    t.string   "code",         limit: 20,                                               null: false
    t.string   "description",  limit: 255,                                              null: false
    t.string   "color",        limit: 50,                                               null: false
    t.decimal  "unit_price",               precision: 18, scale: 2,                     null: false
    t.string   "fabric_state", limit: 20,                           default: "CURRENT", null: false
    t.datetime "created_at",                                                            null: false
    t.datetime "updated_at",                                                            null: false
  end

  add_index "fabrics", ["code"], name: "FABRICS_UNIQUE_CODE", unique: true, where: "((fabric_state)::text = 'CURRENT'::text)", using: :btree

  create_table "inventories", force: :cascade do |t|
    t.integer  "purchase_id",                                     null: false
    t.integer  "fabric_id",                                       null: false
    t.integer  "pieces",                                          null: false
    t.decimal  "amount",                 precision: 10, scale: 2, null: false
    t.string   "unit",        limit: 15,                          null: false
    t.decimal  "unit_price",             precision: 18, scale: 2, null: false
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
  end

  add_index "inventories", ["fabric_id"], name: "index_inventories_on_fabric_id", using: :btree
  add_index "inventories", ["purchase_id"], name: "index_inventories_on_purchase_id", using: :btree

  create_table "invoices", force: :cascade do |t|
    t.integer  "client_id",                                                                null: false
    t.integer  "iva_id",                                                                   null: false
    t.string   "invoice_number",  limit: 50,                                               null: false
    t.decimal  "subtotal",                    precision: 18, scale: 2,                     null: false
    t.date     "invoice_date",                                                             null: false
    t.string   "form_of_payment", limit: 155,                                              null: false
    t.string   "invoice_state",   limit: 20,                           default: "CURRENT", null: false
    t.datetime "created_at",                                                               null: false
    t.datetime "updated_at",                                                               null: false
  end

  add_index "invoices", ["client_id"], name: "index_invoices_on_client_id", using: :btree
  add_index "invoices", ["invoice_number"], name: "INVOICES_UNIQUE_NUMBER", unique: true, using: :btree
  add_index "invoices", ["iva_id"], name: "index_invoices_on_iva_id", using: :btree

  create_table "ivas", force: :cascade do |t|
    t.decimal  "percentage", precision: 5, scale: 2, null: false
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

  add_index "ivas", ["percentage"], name: "IVAS_UNIQUE_PERCENTAGE", unique: true, using: :btree

  create_table "phones", force: :cascade do |t|
    t.string   "country_code", limit: 5,  null: false
    t.string   "area_code",    limit: 5,  null: false
    t.string   "phone_number", limit: 15, null: false
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  add_index "phones", ["country_code", "area_code", "phone_number"], name: "PHONES_UNIQUE_PHONE", unique: true, using: :btree

  create_table "phones_suppliers", force: :cascade do |t|
    t.integer  "phone_id",    null: false
    t.integer  "supplier_id", null: false
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "phones_suppliers", ["phone_id"], name: "index_phones_suppliers_on_phone_id", using: :btree
  add_index "phones_suppliers", ["supplier_id"], name: "index_phones_suppliers_on_supplier_id", using: :btree

  create_table "purchases", force: :cascade do |t|
    t.integer  "supplier_id",                                                              null: false
    t.integer  "iva_id",                                                                   null: false
    t.string   "purchase_number", limit: 50,                                               null: false
    t.decimal  "subtotal",                    precision: 18, scale: 2,                     null: false
    t.string   "form_of_payment", limit: 155,                                              null: false
    t.date     "purchase_date",                                                            null: false
    t.string   "purchase_state",  limit: 20,                           default: "CURRENT", null: false
    t.datetime "created_at",                                                               null: false
    t.datetime "updated_at",                                                               null: false
  end

  add_index "purchases", ["iva_id"], name: "index_purchases_on_iva_id", using: :btree
  add_index "purchases", ["supplier_id", "purchase_number"], name: "PURCHASES_UNIQUE_NUMBER", unique: true, where: "((purchase_state)::text = 'CURRENT'::text)", using: :btree
  add_index "purchases", ["supplier_id"], name: "index_purchases_on_supplier_id", using: :btree

  create_table "sales", force: :cascade do |t|
    t.integer  "invoice_id",                                       null: false
    t.integer  "inventory_id",                                     null: false
    t.integer  "pieces",                                           null: false
    t.decimal  "amount",                  precision: 10, scale: 2, null: false
    t.string   "unit",         limit: 15,                          null: false
    t.decimal  "unit_price",              precision: 18, scale: 2, null: false
    t.datetime "created_at",                                       null: false
    t.datetime "updated_at",                                       null: false
  end

  add_index "sales", ["inventory_id"], name: "index_sales_on_inventory_id", using: :btree
  add_index "sales", ["invoice_id"], name: "index_sales_on_invoice_id", using: :btree

  create_table "suppliers", force: :cascade do |t|
    t.string   "supplier_name",  limit: 155,                     null: false
    t.string   "type_id",        limit: 5,                       null: false
    t.string   "number_id",      limit: 50,                      null: false
    t.string   "address",        limit: 255
    t.string   "email",          limit: 25
    t.string   "supplier_state", limit: 20,  default: "CURRENT", null: false
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
  end

  add_index "suppliers", ["type_id", "number_id"], name: "SUPPLIERS_UNIQUE_ID", unique: true, where: "((supplier_state)::text = 'CURRENT'::text)", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "user_name",              limit: 50,              null: false
    t.string   "user_lastname",          limit: 50,              null: false
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
    t.string   "email",                             default: "", null: false
    t.string   "encrypted_password",                default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                     default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "clients_phones", "clients", name: "CLIENTS_PHONES_CLIENTS_FK"
  add_foreign_key "clients_phones", "phones", name: "CLIENTS_PHONES_PHONES_FK"
  add_foreign_key "existences", "inventories", name: "EX_HAVE_INVENTORIES_FK"
  add_foreign_key "inventories", "fabrics", name: "PUR_HAS_FAB_FABRICS_FK"
  add_foreign_key "inventories", "purchases", name: "PUR_HAS_FAB_PURCHASES_FK"
  add_foreign_key "invoices", "clients", name: "INVOICES_CLIENTS_FK"
  add_foreign_key "invoices", "ivas", name: "INVOICES_IVAS_FK"
  add_foreign_key "phones_suppliers", "phones", name: "SUPPLIERS_PHONES_PHONES_FK"
  add_foreign_key "phones_suppliers", "suppliers", name: "SUPPLIERS_PHONES_SUPPLIERS_FK"
  add_foreign_key "purchases", "ivas", name: "PURCHASES_IVAS_FK"
  add_foreign_key "purchases", "suppliers", name: "PURCHASES_SUPPLIERS_FK"
  add_foreign_key "sales", "inventories", name: "SALES_INV_FK"
  add_foreign_key "sales", "invoices", name: "SALES_INVOICES_FK"
end
