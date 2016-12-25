require "rails_helper"

RSpec.describe ExistencesController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/existences").to route_to("existences#index")
    end

    it "routes to #new" do
      expect(:get => "/existences/new").to route_to("existences#new")
    end

    it "routes to #show" do
      expect(:get => "/existences/1").to route_to("existences#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/existences/1/edit").to route_to("existences#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/existences").to route_to("existences#create")
    end

    it "routes to #update via PUT" do
      expect(:put => "/existences/1").to route_to("existences#update", :id => "1")
    end

    it "routes to #update via PATCH" do
      expect(:patch => "/existences/1").to route_to("existences#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/existences/1").to route_to("existences#destroy", :id => "1")
    end

  end
end
