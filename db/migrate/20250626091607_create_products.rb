class CreateProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :products do |t|
      # Basic product info
      t.integer  :database_id
      t.string   :SKU
      t.index    :SKU, unique: true
      t.string   :name
      t.text     :description
      t.integer  :parent_id
      t.string   :colour_value
      t.string   :size_value
      t.decimal  :price, precision: 10, scale: 2
      t.string   :stock_status
      t.integer  :stock_quantity
      t.string   :image_url
      t.string   :slug, index: true
      t.string   :product_type

      # Physical dimensions
      t.decimal  :weight, precision: 6, scale: 2
      t.decimal  :length, precision: 6, scale: 2
      t.decimal  :width,  precision: 6, scale: 2
      t.decimal  :height, precision: 6, scale: 2

      # Optional customization
      t.string   :customiser_template
      t.string   :background_colour
      t.string   :personalisation_options

      # Normalized references (optional foreign keys)
      t.references :quality, foreign_key: true

      t.timestamps
    end
  end
end
