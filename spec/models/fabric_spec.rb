# == Schema Information
#
# Table name: fabrics
#
#  id           :integer          not null, primary key
#  code         :string(20)       not null
#  description  :string(255)
#  color        :string(50)
#  unit_price   :decimal(18, 2)   not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  fabric_state :string(20)       default("CURRENT"), not null
#

require 'rails_helper'

RSpec.describe Fabric, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
