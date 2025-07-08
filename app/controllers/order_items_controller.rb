class OrderItemsController < ApplicationController
  def new
    @order_item = OrderItem.new
  end

  def create
    order = current_order || Order.create(user: current_user, status: "pending")
    @product = Product.find(order_item_params[:product_id])

    @order_item = OrderItem.new
    @order_item.order = order
    @order_item.product = @product
    @order_item.quantity = order_item_params[:quantity].to_i

    if @order_item.save
      session[:order_id] = order.id unless current_user
      redirect_to cart_path, notice: "Added to cart!"
    else
      redirect_back fallback_location: root_path, alert: "Could not add item."
    end
  end

  def update
    @order_item = OrderItem.find(params[:id])
    if @order_item.update(quantity: params[:order_item][:quantity])
      redirect_to cart_path, notice: "Quantity updated."
    else
      redirect_to cart_path, alert: "Could not update item."
    end
  end

  def destroy
    @order_item = OrderItem.find(params[:id])
    @order_item.destroy
    redirect_to cart_path, notice: "Item removed from cart."
  end

  private

  def current_order
    if current_user
      current_user.orders.find_by(status: "pending")
    elsif session[:order_id]
      Order.find_by(id: session[:order_id], status: "pending")
    else
      @order = Order.new(session_id: session[:session_id], status: "pending")
      @order.save!
      @order
    end
  end

  def order_item_params
    params.require(:order_item).permit(:order_id, :product_id, :quantity)
  end
end
