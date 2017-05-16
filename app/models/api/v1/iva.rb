# # == Schema Information
# #
# # Table name: ivas
# #
# #  id         :integer          not null, primary key
# #  percentage :decimal(5, 2)    not null
# #  created_at :datetime         not null
# #  updated_at :datetime         not null
# #

# class Api::V1::Iva < ActiveRecord::Base
#   has_many :invoices
#   has_many :purchases

#   validates :percentage, numericality: { greater_than_or_equal_to: 0 }
# end
