class BulkDiscountsController < ApplicationController
  before_action :current_merchant

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
    redirect_to merchant_bulk_discounts_path(@merchant) if bulk_discount.save
  end

  def destroy
    BulkDiscount.find(params[:id]).destroy
    redirect_to merchant_bulk_discounts_path(@merchant)
  end


  # def edit; end
  private

  def current_bulk_discount
    @bulk_discount = BulkDiscount.find(params[:id])
  end

  def bulk_discount_params
    params.require(:bulk_discount).permit(:quantity, :percentage)
  end
end
