require 'rails_helper'

module Api::V1
  RSpec.describe "Clients", type: :request do
    describe "GET /clients" do
      it "works! (now write some real specs)" do
        get api_v1_clients_path
        expect(response).to have_http_status(200)
      end
    end
  end
end