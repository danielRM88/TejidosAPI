module Api::V1
  class IvasController < ApplicationController
    before_action :set_iva, only: [:show, :update, :destroy]

    # GET /ivas
    # GET /ivas.json
    def index
      @ivas = Iva.all

      render json: @ivas
    end

    # GET /ivas/1
    # GET /ivas/1.json
    def show
      render json: @iva
    end

    # POST /ivas
    # POST /ivas.json
    def create
      @iva = Iva.new(iva_params)

      if @iva.save
        render json: @iva, status: :created, location: @iva
      else
        render json: @iva.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /ivas/1
    # PATCH/PUT /ivas/1.json
    def update
      @iva = Iva.find(params[:id])

      if @iva.update(iva_params)
        head :no_content
      else
        render json: @iva.errors, status: :unprocessable_entity
      end
    end

    # DELETE /ivas/1
    # DELETE /ivas/1.json
    def destroy
      @iva.destroy

      head :no_content
    end

    private

      def set_iva
        @iva = Iva.find(params[:id])
      end

      def iva_params
        params[:iva]
      end
  end
end