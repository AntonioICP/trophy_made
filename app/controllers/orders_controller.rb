class OrdersController < ApplicationController
  before_action :set_order, only: %i[edit update show destroy]


  def index
    @orders = Order.All
  end

  def show
  end

  def new
    @order = Order.new
  end

  def create
    @orer = Order.new(order_params)
    if @order.save!
      redirect_to orders_path, notice: "Order created!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
  end

  def destroy
    @order.destroy
    redirect_to orders_path, status: :set_order
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end

  def order_params
    params.require(:order).permit(:finished)
  end
end
