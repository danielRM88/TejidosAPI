module Api::V1
  class PhonesController < ApplicationController
    before_action :set_phone, only: [:show, :update, :destroy]
    before_action :authenticate_request!

    # GET /phones
    # GET /phones.json
    def index
      @phones = Phone.all

      render json: @phones
    end

    # GET /phones/1
    # GET /phones/1.json
    def show
      render json: @phone
    end

    # POST /phones
    # POST /phones.json
    def create
      @phone = Phone.new(phone_params)

      if @phone.save
        render json: @phone, status: :created, location: @phone
      else
        render json: @phone.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /phones/1
    # PATCH/PUT /phones/1.json
    def update
      @phone = Phone.find(params[:id])

      if @phone.update(phone_params)
        head :no_content
      else
        render json: @phone.errors, status: :unprocessable_entity
      end
    end

    # DELETE /phones/1
    # DELETE /phones/1.json
    def destroy
      @phone.destroy

      head :no_content
    end

    private

      def set_phone
        @phone = Phone.find(params[:id])
      end

      def phone_params
        params[:phone]
      end
  end
end