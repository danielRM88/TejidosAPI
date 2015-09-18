# == Schema Information
#
# Table name: sales
#
#  id              :integer          not null, primary key
#  client_id       :integer          not null
#  iva_id          :integer          not null
#  sale_number     :string(50)       not null
#  subtotal        :decimal(18, 2)   not null
#  sale_date       :date             not null
#  form_of_payment :string(155)      not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  sale_state      :string(20)       default("CURRENT"), not null
#

require 'rails_helper'

RSpec.describe Sale, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
