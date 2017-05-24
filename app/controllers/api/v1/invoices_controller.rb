module Api::V1
  class InvoicesController < ApplicationController
    before_action :set_invoice, only: [:show, :update, :destroy]
    # before_action :authenticate_request!

    # GET /invoices
    # GET /invoices.json
    def index
      @invoices = Invoice.all.order(invoice_date: :desc).order(created_at: :desc).paginate(:page => params[:page], per_page: 10)

      render json: {invoices: @invoices, total_pages: @invoices.total_pages, current_page: @invoices.current_page}
    end

    # GET /invoices/1
    # GET /invoices/1.json
    def show
      render json: @invoice, methods: [:sales]
    end

    # POST /invoices
    # POST /invoices.json
    def create
      @invoice = Invoice.new(invoice_params)
      sales = params[:invoice][:sales_attributes]
      success = false
      
      begin
        @invoice.pick_sales sales
        success = @invoice.save
      rescue Existence::NotEnoughExistence => ex
        @invoice.errors.add :sales, "Not Enough Existence"
        success = false
      rescue
        success = false
      end

      if success
        render json: @invoice, status: :created, location: @invoice
      else
        render json: {errors: @invoice.errors}, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /invoices/1
    # PATCH/PUT /invoices/1.json
    def update
      @invoice = Invoice.find(params[:id])

      success = false
      begin
        ActiveRecord::Base.transaction do
          @invoice.destroy!
          @invoice = Invoice.new(invoice_params)
          sales = params[:invoice][:sales_attributes]
          success = false
          @invoice.pick_sales sales
          success = @invoice.save!
        end
      rescue ActiveRecord::RecordInvalid => ex
        puts ex
      rescue Existence::NotEnoughExistence => ex
        @invoice.errors.add :sales, "Not Enough Existence"
      end

      if success
        head :no_content
      else
        render json: {errors: @invoice.errors}, status: :unprocessable_entity
      end
    end

    # DELETE /invoices/1
    # DELETE /invoices/1.json
    def destroy
      @invoice.destroy

      head :no_content
    end

    def get_next_invoice_number
      render json: { invoice_number: Invoice.next_invoice_number }
    end

    private

      def set_invoice
        @invoice = Invoice.find(params[:id])
      end

      def invoice_params
        params.require(:invoice).permit(:invoice_number, :client_id, :invoice_date, :vat, :form_of_payment)
      end
  end
end