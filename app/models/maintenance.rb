class Maintenance < ApplicationRecord
  CATEGORIES = %w[日常点検 法定点検 メンテナンス チューニング 洗車].freeze

  belongs_to :user
  belongs_to :car
  has_many :steps, -> { order(:position) }, class_name: "MaintenanceStep", dependent: :destroy
  has_many :tools, class_name: "MaintenanceTool", dependent: :destroy
  has_many_attached :images

  enum :work_difficulty, { easy: 0, normal: 1, hard: 2 }, prefix: :difficulty
  enum :status, { draft: 0, published: 1 }, default: :draft

  accepts_nested_attributes_for :steps, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :tools, allow_destroy: true, reject_if: :all_blank

  validates :title, :maintenance_day, :work_difficulty, presence: true
  validates :category, inclusion: { in: CATEGORIES }
  validates :work_time_minutes, :work_cost,
            numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true

  # 公開中で、削除されていない記録だけ
  scope :visible, -> { published.where(deleted_at: nil) }
  scope :latest, -> { order(created_at: :desc) }
end