class CreateCars < ActiveRecord::Migration[8.1]
  def change
    create_table :cars do |t|
      t.references :user, null: false, foreign_key: true
      t.string :manufacturer_name
      t.string :car_model
      t.string :car_name
      t.integer :odometer
      t.string :purpose

      t.timestamps
    end
  end
end
