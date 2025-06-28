class CreateUserDesigns < ActiveRecord::Migration[7.1]
  def change
    create_table :user_designs do |t|
      t.string :cloudinary_url
      t.string :user_text
      t.references :product, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.references :order, null: false, foreign_key: true
      t.boolean :finished

      t.timestamps
    end
  end
end
