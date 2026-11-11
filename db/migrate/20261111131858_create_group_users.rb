class CreateGroupUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :group_users do |t|
      t.references :group, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      # 0: 参加申請中 / 1: メンバー
      t.integer :status, null: false, default: 0

      t.timestamps
      t.index [ :group_id, :user_id ], unique: true
    end
  end
end
