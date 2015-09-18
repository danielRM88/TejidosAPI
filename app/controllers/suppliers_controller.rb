class SuppliersController < ApplicationController
  before_action :set_supplier, only: [:show, :update, :destroy]

  # GET /suppliers
  # GET /suppliers.json
  def index
    @suppliers = Supplier.all

    render json: @suppliers
  end

  # GET /suppliers/1
  # GET /suppliers/1.json
  def show
    render json: @supplier
  end

  # POST /suppliers
  # POST /suppliers.json
  def create
    @supplier = Supplier.new(supplier_params)

    if @supplier.save
      render json: @supplier, status: :created, location: @supplier
    else
      render json: @supplier.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /suppliers/1
  # PATCH/PUT /suppliers/1.json
  def update
    @supplier = Supplier.find(params[:id])

    if @supplier.update(supplier_params)
      head :no_content
    else
      render json: @supplier.errors, status: :unprocessable_entity
    end
  end

  # DELETE /suppliers/1
  # DELETE /suppliers/1.json
  def destroy
    @supplier.destroy

    head :no_content
  end

  private

    def set_supplier
      @supplier = Supplier.find(params[:id])
    end

    def supplier_params
      params[:supplier]
    end
end
