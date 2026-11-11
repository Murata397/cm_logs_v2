# 管理者（ふつうのユーザーとは別のテーブル。新規登録画面はなく、seedで作る）
class Admin < ApplicationRecord
  devise :database_authenticatable, :rememberable, :validatable
end
