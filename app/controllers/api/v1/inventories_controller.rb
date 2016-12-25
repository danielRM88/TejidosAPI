module Api::V1
  class InventoriesController < ApplicationController
    before_action :set_inventory, only: [:show, :update, :destroy]

    # GET /inventories
    # GET /inventories.json
    def index
      @inventories = Inventory.all

      render json: @inventories
    end

    # GET /inventories/1
    # GET /inventories/1.json
    def show
      render json: @inventory
    end

    # POST /inventories
    # POST /inventories.json
    def create
      @inventory = Inventory.new(inventory_params)

      if @inventory.save
        render json: @inventory, status: :created, location: @inventory
      else
        render json: @inventory.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /inventories/1
    # PATCH/PUT /inventories/1.json
    def update
      @inventory = Inventory.find(params[:id])

      if @inventory.update(inventory_params)
        head :no_content
      else
        render json: @inventory.errors, status: :unprocessable_entity
      end
    end

    # DELETE /inventories/1
    # DELETE /inventories/1.json
    def destroy
      @inventory.destroy

      head :no_content
    end

    private

      def set_inventory
        @inventory = Inventory.find(params[:id])
      end

      def inventory_params
        params[:inventory]
      end
  end
end