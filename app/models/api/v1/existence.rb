# == Schema Information
#
# Table name: existences
#
#  id           :integer          not null, primary key
#  inventory_id :integer          not null
#  pieces       :integer          not null
#  amount       :decimal(10, 2)   not null
#  unit         :string(15)       not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Api::V1::Existence < ActiveRecord::Base
  belongs_to :inventory

  class NotEnoughExistence < StandardError; end

  scope :less_amount_and_pieces_with_fabric_id, -> (fabric_id, unit) { joins(:inventory).where(inventories: {fabric_id: fabric_id}).where(unit: unit).order(created_at: :asc).order(amount: :asc).order(pieces: :asc) }
  scope :amount_and_pieces_for_fabric_id, -> (fabric_id, unit) { select(' "inventories"."fabric_id", SUM("existences"."amount") AS amount, SUM("existences"."pieces") pieces ').joins(:inventory).where(inventories: {fabric_id: fabric_id}).where(unit: unit).group(:fabric_id) }

  validates :inventory, presence: true
  validates :pieces, presence: true
  validates :pieces, numericality: { greater_than: 0, only_integer: true }
  validates :amount, presence: true
  validates :amount, numericality: { greater_than: 0 }
  validates :unit, presence: true
  validates :unit, length: { maximum: 15 }

  def self.enough_existence fabric_id, amount, pieces, unit
    existence = Api::V1::Existence.amount_and_pieces_for_fabric_id(fabric_id, unit)

    raise NotEnoughExistence.new("Not Enough Existence") if (existence.blank? || existence[0].amount < amount || existence[0].pieces < pieces)
  end
end
