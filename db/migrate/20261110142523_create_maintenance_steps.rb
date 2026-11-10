class CreateMaintenanceSteps < ActiveRecord::Migration[8.1]
  def change
    create_table :maintenance_steps do |t|
      t.references :maintenance, null: false, foreign_key: true
      t.integer :position
      t.string :title
      t.text :body

      t.timestamps
    end
  end
end
