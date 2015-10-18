require 'rails_helper'

shared_examples "from State Manager" do
  let(:model) { create ( described_class ) }
  
  describe "update without dependencies" do
    it "should not create new record" do
      FactoryGirl.create(:supplier)
      FactoryGirl.create(:supplier2)
      FactoryGirl.create(:iva)
      FactoryGirl.create(:purchase)
      FactoryGirl.create(:purchase2)
      model.get_state.should eq("CURRENT")
      model.update_record
      model.get_state.should eq("CURRENT")
    end
  end
  
end

describe Client do
  include_examples "from State Manager"
end