# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  helper_method :current_user
  before_action :github_api_data
  before_action :holiday_api_data

  private

  def current_merchant
    @merchant = Merchant.find(params[:merchant_id])
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def github_api_data
    @github_api_data ||= GitHubService.new('little-esty-shop')
  end

  def holiday_api_data
    @holiday_api_data ||= PublicHolidaysService.new
  end
end
