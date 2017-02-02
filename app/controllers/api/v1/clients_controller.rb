module Api::V1
  class ClientsController < ApplicationController
    before_action :set_client, only: [:show, :update, :destroy]
    before_action :authenticate_request!
    
    # GET /clients
    # GET /clients.json
    def index
      @clients = Client.all.paginate(:page => params[:page], per_page: 10)

      render json: { clients: @clients, total_pages: @clients.total_pages, current_page: @clients.current_page }
    end

    # GET /clients/1
    # GET /clients/1.json
    def show
      render json: @client
    end

    # POST /clients
    # POST /clients.json
    def create
      @client = Client.new(client_params)

      if @client.save
        render json: @client, status: :created, location: @client
      else
        render json: @client.errors, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /clients/1
    # PATCH/PUT /clients/1.json
    def update
      @client = Client.find(params[:id])

      if @client.update(client_params)
        head :no_content
      else
        render json: @client.errors, status: :unprocessable_entity
      end
    end

    # DELETE /clients/1
    # DELETE /clients/1.json
    def destroy
      @client.destroy

      head :no_content
    end

    private

      def set_client
        @client = Client.find(params[:id])
      end

      def client_params
        params.require(:client).permit(:client_name, :type_id, :number_id, :address, :email)
      end
  end
end