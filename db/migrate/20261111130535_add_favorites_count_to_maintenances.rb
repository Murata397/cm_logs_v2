class AddFavoritesCountToMaintenances < ActiveRecord::Migration[8.1]
  def change
    add_column :maintenances, :favorites_count, :integer, default: 0, null: false
  end
end
