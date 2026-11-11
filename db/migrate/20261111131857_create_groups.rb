class CreateGroups < ActiveRecord::Migration[8.1]
  def change
    create_table :groups do |t|
      # グループを作った人（オーナー）。users テーブルにつなぐ
      t.references :owner, null: false, foreign_key: { to_table: :users }
      t.string :name, null: false
      t.text :introduction
      t.string :theme
      t.text :rules
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
