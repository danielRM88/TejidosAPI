# == Schema Information
#
# Table name: suppliers
#
#  id             :integer          not null, primary key
#  supplier_name  :string(155)      not null
#  type_id        :string(5)        not null
#  number_id      :string(50)       not null
#  address        :string(255)
#  email          :string(25)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  supplier_state :string(20)       default("CURRENT"), not null
#

require 'rails_helper'

module Api::V1
  RSpec.describe Supplier, type: :model do
    subject { FactoryGirl.create :supplier2 }

    it { should validate_presence_of(:supplier_name) }
    it { should validate_length_of(:supplier_name).is_at_most(155) }
    it { should validate_presence_of(:type_id) }
    it { should validate_length_of(:type_id).is_at_most(5) }
    it { should validate_presence_of(:number_id) }
    it { should validate_length_of(:number_id).is_at_most(50) }
    it { should validate_uniqueness_of(:number_id).case_insensitive.scoped_to([:type_id, :supplier_state]) }
    it { should validate_length_of(:address).is_at_most(255) }
    it { should validate_length_of(:email).is_at_most(25) }
    it { should validate_presence_of(:supplier_state) }
    it { should validate_length_of(:supplier_state).is_at_most(20) }
    it { should validate_inclusion_of(:supplier_state).in_array(Stateful::STATES) }

    it "should create new record when updated if it has dependencies" do
      supplier = FactoryGirl.create :supplier2
      purchase = FactoryGirl.create :purchase, vat: 12, supplier: supplier

      supplier.address = "New Address"
      supplier.save

      expect(supplier.supplier_state).to eq(Stateful::UPDATED_STATE)

      new_supplier = Supplier.where(supplier_name: supplier.supplier_name, 
                                type_id: supplier.type_id, 
                                number_id: supplier.number_id, 
                                email: supplier.email, 
                                supplier_state: Stateful::CURRENT_STATE).first

      expect(new_supplier).not_to be_nil
    end

    it "should update status when deleted if it has dependencies" do
      supplier = FactoryGirl.create :supplier2
      purchase = FactoryGirl.create :purchase, vat: 13, supplier: supplier

      supplier.destroy
      expect(supplier.supplier_state).to eq(Stateful::DELETED_STATE)
    end
  end
end