require 'rails_helper'

RSpec.describe "Fabrics", type: :request do
  describe "GET /fabrics" do
    it "works! (now write some real specs)" do
      get fabrics_path
      expect(response).to have_http_status(200)
    end
  end
end
