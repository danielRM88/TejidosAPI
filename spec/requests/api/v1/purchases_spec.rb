require 'rails_helper'

module Api::V1
  RSpec.describe "Purchases", type: :request do
    describe "GET /purchases" do
      it "works! (now write some real specs)" do
        get api_v1_purchases_path
        expect(response).to have_http_status(200)
      end
    end
  end
end