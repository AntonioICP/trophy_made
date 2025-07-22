class OrdersController < ApplicationController
  before_action :set_order, only: %i[edit update show destroy]

  def index
    @orders = current_user.orders if current_user
  end

  def show
  end

  def new
    @product = Product.find(params[:product_id])
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

  def checkout
    @order = current_order

    # Redirect to cart if no items
    if @order.nil? || @order.order_items.empty?
      redirect_to cart_path, alert: 'Your cart is empty'
      return
    end

    # Redirect to login if user is not signed in
    unless user_signed_in?
      # Store the checkout path so user returns here after login
      store_location_for(:user, request.fullpath)
      redirect_to new_user_session_path, alert: 'Please sign in to continue with checkout'
      return
    end

    # User is logged in and has items - proceed to checkout
    # This will render app/views/orders/checkout.html.erb
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end

  def order_params
    params.require(:order).permit(:status, :user_id)
  end
end
