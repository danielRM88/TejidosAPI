require "rails_helper"

RSpec.describe FabricsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/fabrics").to route_to("fabrics#index")
    end

    it "routes to #new" do
      expect(:get => "/fabrics/new").to route_to("fabrics#new")
    end

    it "routes to #show" do
      expect(:get => "/fabrics/1").to route_to("fabrics#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/fabrics/1/edit").to route_to("fabrics#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/fabrics").to route_to("fabrics#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/fabrics/1").to route_to("fabrics#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/fabrics/1").to route_to("fabrics#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/fabrics/1").to route_to("fabrics#destroy", :id => "1")
    end

  end
end
