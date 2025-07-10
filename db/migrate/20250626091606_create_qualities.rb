class CreateQualities < ActiveRecord::Migration[7.1]
  def change
    create_table :qualities do |t|
      t.string :name

      t.timestamps
    end
  end
end
