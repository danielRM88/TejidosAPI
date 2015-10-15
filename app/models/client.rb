# == Schema Information
#
# Table name: clients
#
#  id           :integer          not null, primary key
#  client_name  :string(50)       not null
#  type_id      :string(5)        not null
#  number_id    :string(50)       not null
#  address      :string(255)
#  email        :string(25)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  client_state :string(20)       default("CURRENT"), not null
#

class Client < ActiveRecord::Base

  include StateManager

  has_many :invoices
  has_and_belongs_to_many :phones

  validates :number_id, uniqueness: {scope: [:type_id, :client_state], message: "The client RIF (type_id, number_id) must be unique"}

private
  def get_state_field
    return :client_state
  end

  def change_state state
    self.client_state = state
  end

  def count_dependencies
    self.invoices.count
  end

  def get_state
    self.client_state
  end
end
