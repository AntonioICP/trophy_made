require 'csv'

class Admin::DashboardController < Admin::ApplicationController
  def index
    @total_orders = Order.count
    @pending_orders = Order.where(status: 'pending').count
    @recent_orders = Order.order(created_at: :desc).limit(10)
    @total_users = User.count
    @total_products = Product.count
  end
end
