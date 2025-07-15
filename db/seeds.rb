require 'csv'

Product.destroy_all

CSV.foreach("db/data/TrophyMade DB_2.csv", headers: true) do |row|
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

  # Corporate categories
  row["corporate_category"].to_s.split(",").map(&:strip).uniq.each do |corporate|
    category = CorporateCategory.find_or_create_by(name: corporate)
    product.corporate_categories << category unless product.corporate_categories.include?(category)
  end

  # Sports categories
  row["sports_category"].to_s.split(",").map(&:strip).uniq.each do |sport|
    sport_record = Sport.find_or_create_by(name: sport)
    product.sports << sport_record unless product.sports.include?(sport_record)
  end

  # Material categories
  row["material"].to_s.split(",").map(&:strip).uniq.each do |material|
    material_record = Material.find_or_create_by(name: material)
    product.materials << material_record unless product.materials.include?(material_record)
  end

  # Product_styles categories
  row["product_style"].to_s.split(",").map(&:strip).uniq.each do |style|
    style_record = ProductStyle.find_or_create_by(name: style)
    product.product_styles << style_record unless product.product_styles.include?(style_record)
  end
end

puts "Imported: #{Product.count} products"
