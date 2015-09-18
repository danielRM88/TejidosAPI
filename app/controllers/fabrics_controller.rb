class FabricsController < ApplicationController
  before_action :set_fabric, only: [:show, :update, :destroy]

  # GET /fabrics
  # GET /fabrics.json
  def index
    @fabrics = Fabric.all

    render json: @fabrics
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
      params[:fabric]
    end
end
