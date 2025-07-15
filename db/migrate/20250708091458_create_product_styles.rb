class CreateProductStyles < ActiveRecord::Migration[7.1]
  def change
    create_table :product_styles do |t|
      t.string :name

      t.timestamps
    end
  end
end
