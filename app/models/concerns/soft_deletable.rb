# データを消さずに「削除した印（deleted_at）」をつける仕組み（論理削除）
#   あとから管理画面で元に戻せる
module SoftDeletable
  extend ActiveSupport::Concern

  included do
    scope :kept, -> { where(deleted_at: nil) }
    scope :soft_deleted, -> { where.not(deleted_at: nil) }
  end

  def soft_delete!
    update_column(:deleted_at, Time.current)
  end

  def restore!
    update_column(:deleted_at, nil)
  end

  def deleted?
    deleted_at.present?
  end
end
