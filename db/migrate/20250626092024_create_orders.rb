class CreateOrders < ActiveRecord::Migration[7.1]
  def change
    create_table :orders do |t|
      t.references :user, null: true, foreign_key: true
      t.string :session_id, null: true
      t.string :status, default: "pending", null: false

      t.timestamps
    end
  end
end
