class Comment < ApplicationRecord
  include SoftDeletable

  belongs_to :user
  belongs_to :maintenance

  # 管理者が隠したものと、退会した人のコメントは出さない
  scope :visible, -> { kept.where(user_id: User.active.select(:id)) }

  validates :body, presence: true, length: { maximum: 500 }
end
