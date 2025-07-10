class CreateJoinTableProductsCorporateCategories < ActiveRecord::Migration[7.1]
  def change
    create_join_table :products, :corporate_categories do |t|
      # t.index [:product_id, :corporate_category_id]
      # t.index [:corporate_category_id, :product_id]
    end
  end
end
