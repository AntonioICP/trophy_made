class Admin::OrdersController < Admin::ApplicationController
  before_action :set_order, only: [:show, :edit, :update]

  def index
    @orders = Order.includes(:user, :order_items, :products)
                   .order(created_at: :desc)
    # Remove the .page(params[:page]) line

    # Add filtering if needed
    @orders = @orders.where(status: params[:status]) if params[:status].present?
  end

  def show
    @order_items = @order.order_items.includes(:product)
  end

  def edit
  end

  def update
    if @order.update(order_params)
      redirect_to admin_order_path(@order), notice: 'Order updated successfully.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end

  def order_params
    params.require(:order).permit(:status)
  end
end
