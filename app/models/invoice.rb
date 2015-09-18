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

class Invoice < ActiveRecord::Base
end
