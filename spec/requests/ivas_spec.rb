require 'rails_helper'

RSpec.describe "Ivas", type: :request do
  describe "GET /ivas" do
    it "works! (now write some real specs)" do
      get ivas_path
      expect(response).to have_http_status(200)
    end
  end
end
