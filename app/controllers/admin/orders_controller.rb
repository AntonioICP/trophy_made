class Admin::OrdersController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_admin
  before_action :set_order, only: [:show, :edit, :update, :cancel]

  def index
    @orders = Order.all.order(created_at: :desc)
    # Add filtering logic here if needed
  end

  def show
  end

  def edit
  end

  def update
    if @order.update(order_params)
      redirect_to admin_order_path(@order), notice: 'Order was successfully updated.'
    else
      render :edit
    end
  end

  def cancel
    if @order.status == 'cancelled'
      redirect_to admin_order_path(@order), alert: 'Order is already cancelled.'
      return
    end

    if @order.status == 'delivered'
      redirect_to admin_order_path(@order), alert: 'Cannot cancel a delivered order.'
      return
    end

    @order.update!(status: 'cancelled')
    redirect_to admin_order_path(@order), notice: 'Order has been cancelled successfully.'
  end

  def bulk_cancel
    order_ids = params[:order_ids]

    if order_ids.blank?
      render json: { success: false, message: 'No orders selected' }
      return
    end

    orders = Order.where(id: order_ids)
    cancelled_count = 0
    skipped_count = 0

    orders.each do |order|
      if order.status == 'cancelled' || order.status == 'delivered'
        skipped_count += 1
      else
        order.update!(status: 'cancelled')
        cancelled_count += 1
      end
    end

    message = "#{cancelled_count} orders cancelled"
    message += ", #{skipped_count} orders skipped (already cancelled or delivered)" if skipped_count > 0

    render json: {
      success: true,
      message: message,
      cancelled_count: cancelled_count,
      skipped_count: skipped_count
    }
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end

  def ensure_admin
    redirect_to root_path unless current_user&.admin?
  end

  def order_params
    params.require(:order).permit(:status)
  end
end
