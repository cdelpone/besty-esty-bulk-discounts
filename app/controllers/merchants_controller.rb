# frozen_string_literal: true

class MerchantsController < ApplicationController
  before_action :current_merchant, only: :show
  before_action :holiday_api_data

  def index
    @merchants = Merchant.all
  end

  def show
    @customers = @merchant.fav_customers
    @items = @merchant.items_ready_to_ship
  end
end
