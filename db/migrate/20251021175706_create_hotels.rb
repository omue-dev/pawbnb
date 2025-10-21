class CreateHotels < ActiveRecord::Migration[7.1]
  def change
    create_table :hotels do |t|
      t.string :name
      t.text :description
      t.string :address
      t.decimal :price_per_night
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
