class CreateFuelLogs < ActiveRecord::Migration[8.1]
  def change
    create_table :fuel_logs do |t|
      t.references :car, null: false, foreign_key: true
      t.date :refueled_on
      t.integer :odometer
      t.decimal :trip_distance
      t.decimal :fuel_amount
      t.string :fuel_type

      t.timestamps
    end
  end
end
