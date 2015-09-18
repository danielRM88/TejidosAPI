# == Schema Information
#
# Table name: ivas
#
#  id         :integer          not null, primary key
#  percentage :decimal(5, 2)    not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Iva < ActiveRecord::Base
end
