require 'rails_helper'

module Api::V1
  RSpec.describe "Fabrics", type: :request do
    describe "GET /fabrics" do
      it "works! (now write some real specs)" do
        get api_v1_fabrics_path
        expect(response).to have_http_status(200)
      end
    end
  end
end