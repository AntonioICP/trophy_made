class Admin::ProductsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_admin

  def index
    @total_products = Product.count
  end

  def upload_csv
    if params[:csv_file].present?
      Order.destroy_all
      Product.destroy_all # Clear existing products before importing

      CSV.foreach(params[:csv_file].path, headers: true) do |row|
        create_product_from_row(row)
      end
      flash[:notice] = "CSV uploaded and processed!"
    else
      flash[:alert] = "Please select a CSV file."
    end
    redirect_to admin_products_path
  end

  private

  def ensure_admin
    redirect_to root_path unless current_user&.admin?
  end

  def create_product_from_row(row)
    product = Product.create!(
      database_id: row["database_id"],
      SKU: row["SKU"],
      name: row["name"],
      description: row["description"],
      parent_id: row["parent_id"],
      colour_value: row["colour_value"],
      size_value: row["size_value"],
      price: row["price"],
      stock_status: row["stock_status"],
      stock_quantity: row["stock_quantity"],
      image_url: row["image_url"].to_s.split("|").first&.strip,
      slug: row["slug"],
      product_type: row["product_type"],
      weight: row["weight"],
      length: row["length"],
      width: row["width"],
      height: row["height"],
      customiser_template: row["customiser_template"],
      background_colour: row["Background Colour"],
      personalisation_options: row["Personalisation Options"],
      quality: Quality.find_or_create_by(name: row["quality"])
    )

    row["corporate_category"].to_s.split(",").map(&:strip).uniq.each do |corporate|
      category = CorporateCategory.find_or_create_by(name: corporate)
      product.corporate_categories << category unless product.corporate_categories.include?(category)
    end

    row["sports_category"].to_s.split(",").map(&:strip).uniq.each do |sport|
      sport_record = Sport.find_or_create_by(name: sport)
      product.sports << sport_record unless product.sports.include?(sport_record)
    end

    row["material"].to_s.split(",").map(&:strip).uniq.each do |material|
      material_record = Material.find_or_create_by(name: material)
      product.materials << material_record unless product.materials.include?(material_record)
    end

    row["product_style"].to_s.split(",").map(&:strip).uniq.each do |style|
      style_record = ProductStyle.find_or_create_by(name: style)
      product.product_styles << style_record unless product.product_styles.include?(style_record)
    end
  end
end
