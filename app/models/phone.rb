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

class Phone < ActiveRecord::Base
  has_and_belongs_to_many :clients
end
