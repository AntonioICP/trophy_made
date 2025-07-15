class CreateJoinTableProductsMaterials < ActiveRecord::Migration[7.1]
  def change
    create_join_table :products, :materials do |t|
      # t.index [:product_id, :material_id]
      # t.index [:material_id, :product_id]
    end
  end
end
