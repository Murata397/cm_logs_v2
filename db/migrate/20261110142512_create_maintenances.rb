class CreateMaintenances < ActiveRecord::Migration[8.1]
  def change
    create_table :maintenances do |t|
      t.references :user, null: false, foreign_key: true
      t.references :car, null: false, foreign_key: true
      t.string :title
      t.date :maintenance_day
      t.string :category
      t.integer :work_difficulty
      t.integer :work_time_minutes
      t.integer :work_cost
      t.text :summary
      t.text :related_information
      t.integer :status
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
