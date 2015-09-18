# == Schema Information
#
# Table name: ivas
#
#  id         :integer          not null, primary key
#  percentage :decimal(5, 2)    not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Iva, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
