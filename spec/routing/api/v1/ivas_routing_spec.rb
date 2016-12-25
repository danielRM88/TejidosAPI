# require "rails_helper"

# module Api::V1
#   RSpec.describe IvasController, type: :routing do
#     describe "routing" do

#       it "routes to #index" do
#         expect(:get => "/ivas").to route_to("ivas#index")
#       end

#       it "routes to #new" do
#         expect(:get => "/ivas/new").to route_to("ivas#new")
#       end

#       it "routes to #show" do
#         expect(:get => "/ivas/1").to route_to("ivas#show", :id => "1")
#       end

#       it "routes to #edit" do
#         expect(:get => "/ivas/1/edit").to route_to("ivas#edit", :id => "1")
#       end

#       it "routes to #create" do
#         expect(:post => "/ivas").to route_to("ivas#create")
#       end

#       it "routes to #update via PUT" do
#         expect(:put => "/ivas/1").to route_to("ivas#update", :id => "1")
#       end

#       it "routes to #update via PATCH" do
#         expect(:patch => "/ivas/1").to route_to("ivas#update", :id => "1")
#       end

#       it "routes to #destroy" do
#         expect(:delete => "/ivas/1").to route_to("ivas#destroy", :id => "1")
#       end

#     end
#   end
# end