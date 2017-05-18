module Api::V1
  class FabricsController < ApplicationController
    before_action :set_fabric, only: [:show, :update, :destroy]
    before_action :authenticate_request!

    # GET /fabrics
    # GET /fabrics.json
    def index
      code = params[:code]

      @fabrics = Fabric.current.paginate(:page => params[:page], per_page: 10)
      
      if !code.blank?
        @fabrics = @fabrics.with_similar_code code
      end

      render json: {fabrics: @fabrics, total_pages: @fabrics.total_pages, current_page: @fabrics.current_page}
    end

    # GET /fabrics/1
    # GET /fabrics/1.json
    def show
      render json: @fabric
    end

    # POST /fabrics
    # POST /fabrics.json
    def create
      @fabric = Fabric.new(fabric_params)

      if @fabric.save
        render json: @fabric, status: :created, location: @fabric
      else
        render json: @fabric.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /fabrics/1
    # PATCH/PUT /fabrics/1.json
    def update
      @fabric = Fabric.find(params[:id])

      if @fabric.update(fabric_params)
        head :no_content
      else
        render json: @fabric.errors, status: :unprocessable_entity
      end
    end

    # DELETE /fabrics/1
    # DELETE /fabrics/1.json
    def destroy
      @fabric.destroy

      head :no_content
    end

    private

      def set_fabric
        @fabric = Fabric.find(params[:id])
      end

      def fabric_params
        params.require(:fabric).permit(:code, :description, :color, :unit_price)
      end
  end
end