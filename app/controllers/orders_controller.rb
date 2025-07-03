class OrdersController < ApplicationController
  before_action :set_order, only: %i[edit update show destroy]


  def index
    @orders = Order.all
  end

  def show
    if @order.session_id == session[:session_id]
      @order
    else
      redirect_to root_path, notice: "Not your order!"
    end
  end

  def new
    @order = Order.new
  end

  def create
    @order = Order.new(order_params)
    if @order.save
      redirect_to orders_path, notice: "Order created!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @order.update(order_params)
      redirect_to order_path(@order), notice: "Order updated!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @order.destroy
    redirect_to orders_path, status: :see_other, notice: "Order deleted!"
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end

  def order_params
    params.require(:order).permit(:status, :user_id)
  end
end
