class ApplicationController < ActionController::Base
  helper_method :current_order
  before_action :set_navbar_data

  # before_action :authenticate_user!

  def current_order
    @current_order ||= if current_user
      # For logged-in users, find or create an order associated with the user
      current_user.orders.find_or_create_by(status: "pending")
    else
      # For guest users, use session-based orders
      Order.find_or_create_by(id: session[:order_id], status: "pending").tap do |order|
        session[:order_id] = order.id
      end
    end
  end

  protected

  def after_sign_out_path_for(resource_or_scope)
    root_path
  end

  def after_sign_in_path_for(resource)
    merge_guest_cart_with_user_cart if session[:order_id].present?
    stored_location_for(resource) || root_path
  end

  private

  def merge_guest_cart_with_user_cart
    guest_order = Order.find_by(id: session[:order_id], status: "pending")
    return unless guest_order&.order_items&.any?

    user_order = current_user.orders.find_or_create_by(status: "pending")

    guest_order.order_items.each do |guest_item|
      # Check if user already has this product in their cart
      existing_item = user_order.order_items.find_by(product: guest_item.product)

      if existing_item
        # Add quantities together
        existing_item.update(quantity: existing_item.quantity + guest_item.quantity)
      else
        # Transfer the item to user's cart
        guest_item.update(order: user_order)
      end
    end

    # Clean up the empty guest order
    guest_order.destroy if guest_order.order_items.empty?

    # Clear the session
    session[:order_id] = nil

    # Reset the current_order cache
    @current_order = nil
  end

  def set_navbar_data
    sport_names = ["Academic", "Baseball", "Basketball", "Distinctive", "Fantasy Sport", "Football", "Golf", "Hockey", "Music", "Soccer", "Victory", "Your Club Logo"]
    @sports_for_menu = Sport.joins(:products)
                            .where(name: sport_names)
                            .distinct
                            .order(:name)

    corporate_awards_names = ["Economy Acrylic", "Crystal", "Corporate Golf Day", "Giftware", "Economy Glass", "Economy Plaques", "Prestige Acrylic", "Prestige Glass", "Prestige Plaques"]
    @corporate_awards_for_menu = CorporateCategory.joins(:products)
                                                  .where(corporate_categories: { name: corporate_awards_names })
                                                  .distinct
                                                  .order(:name)

    sports_medals_names = ["1st / 2nd / 3rd Place", "Academic", "Achievements", "Baseball", "Basketball", "Cross Country", "Drama", "Footbal", "Gymnastics", "Hockey", "Karate", "Music", "MVP", "Rugby", "Soccer", "Swimming", "Track", "Volleyball", "Wrestling", "Your Club Logo"]
    @medals_sports_for_menu = Sport.joins(products: :product_styles)
                            .where(product_styles: { name: "Medals" })
                            .where(name: sports_medals_names)
                            .distinct
                            .order(:name)

    quality_names = ["Prestige", "Economy"]
    @cup_names = ["Cups", "Extra Large Cups"]

    @cups_qualities_for_menu = Quality.joins(:products)
                                      .joins(products: :product_styles)
                                      .where(product_styles: { name: @cup_names })
                                      .where(qualities: { name: quality_names })
                                      .distinct
                                      .order(:name)

    quality_plaques = ["Prestige Plaques", "Economy Plaques"]
    @plaques_qualities_for_menu = CorporateCategory.joins(:products)
                                         .joins(products: :product_styles)
                                         .where(product_styles: { name: "Plaques"})
                                         .where(corporate_categories: { name: quality_plaques })
                                         .distinct
                                         .order(:name)
  end
end
