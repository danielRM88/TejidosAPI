require 'rails_helper'

module Api::V1
  RSpec.describe "Phones", type: :request do
    describe "GET /phones" do
      it "works! (now write some real specs)" do
        get api_v1_phones_path
        expect(response).to have_http_status(200)
      end
    end
  end
end