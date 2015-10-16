require 'rails_helper'

shared_examples "from State Manager" do
  let(:model) { create ( described_class ) }

  model.inspect
end