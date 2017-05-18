module Api::V1
  class StocksController < ApplicationController
    before_action :authenticate_request!
    
    # GET /stocks
    # GET /stocks.json
    def index
      @stocks = Existence.amount_and_pieces_by_fabric_id.paginate(:page => params[:page], per_page: 10)

      render json: { stocks: @stocks, total_pages: @stocks.total_pages, current_page: @stocks.current_page }
    end

  end
end