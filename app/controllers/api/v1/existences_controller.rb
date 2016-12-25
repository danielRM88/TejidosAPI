module Api::V1
  class ExistencesController < ApplicationController
    before_action :set_existence, only: [:show, :update, :destroy]

    # GET /existences
    # GET /existences.json
    def index
      @existences = Existence.all

      render json: @existences
    end

    # GET /existences/1
    # GET /existences/1.json
    def show
      render json: @existence
    end

    # POST /existences
    # POST /existences.json
    def create
      @existence = Existence.new(existence_params)

      if @existence.save
        render json: @existence, status: :created, location: @existence
      else
        render json: @existence.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /existences/1
    # PATCH/PUT /existences/1.json
    def update
      @existence = Existence.find(params[:id])

      if @existence.update(existence_params)
        head :no_content
      else
        render json: @existence.errors, status: :unprocessable_entity
      end
    end

    # DELETE /existences/1
    # DELETE /existences/1.json
    def destroy
      @existence.destroy

      head :no_content
    end

    private

      def set_existence
        @existence = Existence.find(params[:id])
      end

      def existence_params
        params[:existence]
      end
  end
end