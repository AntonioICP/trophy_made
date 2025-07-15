class ApplicationController < ActionController::Base
  helper_method :current_order
  before_action :set_navbar_data

  # before_action :authenticate_user!

  def current_order
    @current_order ||= Order.find_or_create_by(id: session[:order_id], status: "pending").tap do |order|
      session[:order_id] = order.id
    end
  end

  private

  def set_navbar_data
    sport_names = ["Academic", "Baseball", "Basketball", "Distinctive", "Fantasy Sport", "Football", "Golf", "Hockey", "Music", "Soccer", "Victory"]
    @sports_for_menu = Sport.joins(:products)
                            .where(sports: { name: sport_names })
                            .distinct
                            .order(:name)

    corporate_awards_names = ["Economy Acrylic", "Crystal", "Corporate Golf Day", "Giftware", "Economy Glass", "Economy Plaques", "Prestige Acrylic", "Prestige Glass", "Prestige Plaques"]
    @corporate_awards_for_menu = CorporateCategory.joins(:products)
                                                  .where(corporate_categories: { name: corporate_awards_names })
                                                  .distinct
                                                  .order(:name)
  end
end
