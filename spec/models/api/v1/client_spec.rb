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

require 'rails_helper'

module Api::V1
  RSpec.describe Client, type: :model do
    subject { FactoryGirl.create :client }

    it { should validate_presence_of(:client_name) }
    it { should validate_length_of(:client_name).is_at_most(50) }
    it { should validate_presence_of(:type_id) }
    it { should validate_length_of(:type_id).is_at_most(5) }
    it { should validate_presence_of(:number_id) }
    it { should validate_length_of(:number_id).is_at_most(50) }
    it { should validate_uniqueness_of(:number_id).case_insensitive.scoped_to([:type_id, :client_state]) }
    it { should validate_length_of(:address).is_at_most(255) }
    it { should validate_length_of(:email).is_at_most(25) }
    it { should validate_presence_of(:client_state) }
    it { should validate_length_of(:client_state).is_at_most(20) }
    it { should validate_inclusion_of(:client_state).in_array(Stateful::STATES) }

    it "should create new record when updated if it has dependencies" do
      client = FactoryGirl.create :client2
      invoice = FactoryGirl.create :invoice, client: client

      client.address = "New Address"
      client.save

      expect(client.client_state).to eq(Stateful::UPDATED_STATE)

      new_client = Client.where(client_name: client.client_name, 
                                type_id: client.type_id, 
                                number_id: client.number_id, 
                                email: client.email, 
                                client_state: Stateful::CURRENT_STATE).first

      expect(new_client).not_to be_nil
    end

    it "should update status when deleted if it has dependencies" do
      client = FactoryGirl.create :client
      invoice = FactoryGirl.create :invoice, client: client

      client.destroy
      expect(client.client_state).to eq(Stateful::DELETED_STATE)
    end
  end
end
