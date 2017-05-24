module Api::V1
  class SuppliersController < ApplicationController
    before_action :set_supplier, only: [:show, :update, :destroy]
    before_action :authenticate_request!

    # GET /suppliers
    # GET /suppliers.json
    def index
      type_id = params[:type_id]
      number_id = params[:number_id]
      @suppliers = Supplier.current.paginate(:page => params[:page], per_page: 10)

      if !type_id.blank? && !number_id.blank?
        @suppliers = @suppliers.with_similar_type_and_number_id type_id, number_id
      end

      render json: { suppliers: @suppliers, total_pages: @suppliers.total_pages, current_page: @suppliers.current_page }
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
        render json: {errors: @supplier.errors}, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /suppliers/1
    # PATCH/PUT /suppliers/1.json
    def update
      @supplier = Supplier.find(params[:id])

      if @supplier.update(supplier_params)
        head :no_content
      else
        render json: {errors: @supplier.errors}, status: :unprocessable_entity
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
        params.require(:supplier).permit(:supplier_name, :type_id, :number_id, :address, :email)
      end
  end
end