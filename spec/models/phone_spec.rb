# == Schema Information
#
# Table name: phones
#
#  id           :integer          not null, primary key
#  country_code :string(5)        not null
#  area_code    :string(5)        not null
#  phone_number :string(15)       not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'rails_helper'

RSpec.describe Phone, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
