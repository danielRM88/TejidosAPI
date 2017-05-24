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

class Api::V1::Phone < ActiveRecord::Base
  has_and_belongs_to_many :clients, inverse_of: :phones
  has_and_belongs_to_many :suppliers

  validates :country_code, presence: true
  validates :country_code, length: { maximum: 5 }
  validates :area_code, presence: true
  validates :area_code, length: { maximum: 5 }
  validates :phone_number, presence: true
  validates :phone_number, length: { maximum: 15 }
end
