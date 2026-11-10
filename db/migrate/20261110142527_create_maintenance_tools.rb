class CreateMaintenanceTools < ActiveRecord::Migration[8.1]
  def change
    create_table :maintenance_tools do |t|
      t.references :maintenance, null: false, foreign_key: true
      t.string :name

      t.timestamps
    end
  end
end
