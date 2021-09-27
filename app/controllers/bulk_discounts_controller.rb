class BulkDiscountsController < ApplicationController
  before_action :current_merchant
  before_action :holiday_api_data

  def index
    @bulk_discounts = @merchant.bulk_discounts
  end

  def show
    @bulk_discount = BulkDiscount.find(params[:id])
  end

  def new
    @bulk_discount = BulkDiscount.new
  end

  def create
    bulk_discount = BulkDiscount.new(bulk_discount_params.merge({ merchant_id: params[:merchant_id] }))
    if bulk_discount.save
      flash[:success] = 'Successfully Created'
      redirect_to merchant_bulk_discounts_path(@merchant)
    else
      flash[:alert] = 'Do Better'
      redirect_to new_merchant_bulk_discount_path(@merchant, @bulk_discount)
    end
  end

  def destroy
    BulkDiscount.find(params[:id]).destroy
    redirect_to merchant_bulk_discounts_path(@merchant)
  end

  def edit
    @bulk_discount = BulkDiscount.find(params[:id])
  end

  def update
    @bulk_discount = BulkDiscount.find(params[:id])
    if @bulk_discount.update(bulk_discount_params)
      flash[:success] = 'Successfully Updated'
      redirect_to merchant_bulk_discount_path(@merchant, @bulk_discount)
    else
      flash[:alert] = 'Do Better'
      redirect_to edit_merchant_bulk_discount_path(@merchant, @bulk_discount)
    end
  end

  private

  def current_bulk_discount
    @bulk_discount = BulkDiscount.find(params[:id])
  end

  def bulk_discount_params
    params.require(:bulk_discount).permit(:quantity, :percentage)
  end
end
