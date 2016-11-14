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
  subject { FactoryGirl.create :iva3 }
  it { should validate_numericality_of(:percentage).is_greater_than_or_equal_to(0) }
end
