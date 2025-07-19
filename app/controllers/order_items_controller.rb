class OrderItemsController < ApplicationController
  def new
    @order_item = OrderItem.new
  end

  def create
    order = current_order
    @product = Product.find(order_item_params[:product_id])

    # Check if item already exists in cart
    existing_item = order.order_items.find_by(product: @product)

    if existing_item
      # Update quantity if item exists
      existing_item.update(quantity: existing_item.quantity + order_item_params[:quantity].to_i)
      redirect_to cart_path, notice: "Updated quantity in cart!"
    else
      # Create new item
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
    # Use the application controller's current_order method
    super
  end

  def order_item_params
    params.require(:order_item).permit(:product_id, :quantity)
  end
end
