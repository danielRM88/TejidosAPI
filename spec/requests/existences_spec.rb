require 'rails_helper'

RSpec.describe "Existences", type: :request do
  describe "GET /existences" do
    it "works! (now write some real specs)" do
      get existences_path
      expect(response).to have_http_status(200)
    end
  end
end
