class CreateInspectionSchedules < ActiveRecord::Migration[8.1]
  def change
    create_table :inspection_schedules do |t|
      t.references :car, null: false, foreign_key: true
      t.string :item
      t.date :next_due_on
      t.integer :next_due_odometer

      t.timestamps
    end
  end
end
