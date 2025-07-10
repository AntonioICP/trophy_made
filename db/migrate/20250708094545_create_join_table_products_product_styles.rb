class CreateJoinTableProductsProductStyles < ActiveRecord::Migration[7.1]
  def change
    create_join_table :products, :product_styles do |t|
      # t.index [:product_id, :product_style_id]
      # t.index [:product_style_id, :product_id]
    end
  end
end
