class CreateProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :products do |t|
      t.string :name
      t.string :description
      t.string :category
      t.string :material
      t.string :image_url
      t.float :price

      t.timestamps
    end
  end
end
