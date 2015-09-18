# == Schema Information
#
# Table name: purchases
#
#  id              :integer          not null, primary key
#  supplier_id     :integer          not null
#  iva_id          :integer          not null
#  purchase_number :string(50)       not null
#  subtotal        :decimal(18, 2)   not null
#  form_of_payment :string(155)
#  purchase_date   :date             not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  purchase_state  :string(20)       default("CURRENT"), not null
#

class Purchase < ActiveRecord::Base
end
