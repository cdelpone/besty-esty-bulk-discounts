class Admin::MerchantsController < ApplicationController
  before_action :find_merchant, except: [:new, :create, :index]

  def index
    @merchants = Merchant.all
  end

  def show
  end

  def new
    @merchant = Merchant.new
  end

  def create
    @merchant = Merchant.new(merchant_params.merge({id: next_id}))
    if @merchant.save
      flash[:success] = "New merchant created"
      redirect_to admin_merchants_path
    else
      flash[:alert] = "That's not a name, fool"
      redirect_to new_admin_merchant_path
    end
  end

  def edit
  end

  def update
    if @merchant.update(merchant_params)
      flash[:success] = "Successfully updated merchant"
      updates_redirect_location
    else
      flash[:alert] = "Invalid name, fool"
      redirect_to edit_admin_merchant_path(@merchant)
    end
  end

  private

  def merchant_params
    params.require(:merchant).permit(:name, :status)
  end

  def updates_redirect_location
    if params[:merchant][:status].present?
      redirect_to admin_merchants_path
    else
      redirect_to admin_merchant_path(@merchant)
    end
  end

  def next_id
    Merchant.get_highest_id + 1
  end

  def find_merchant
    @merchant = Merchant.find(params[:id])
  end
end
