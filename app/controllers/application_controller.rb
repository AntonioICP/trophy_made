class ApplicationController < ActionController::Base
  helper_method :current_order
  before_action :set_navbar_data

  # before_action :authenticate_user!

  def current_order
    @current_order ||= Order.find_or_create_by(id: session[:order_id], status: "pending").tap do |order|
      session[:order_id] = order.id
    end
  end

  protected

  def after_sign_out_path_for(resource_or_scope)
    root_path
  end

  private

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
