class Maintenance < ApplicationRecord
  include SoftDeletable

  CATEGORIES = %w[日常点検 法定点検 メンテナンス チューニング 洗車].freeze
  SORTS = {
    "new" => "新着順",
    "popular" => "人気順",
    "cost" => "費用が安い順",
    "time" => "作業時間が短い順"
  }.freeze

  belongs_to :user
  belongs_to :car
  has_many :steps, -> { order(:position) }, class_name: "MaintenanceStep", dependent: :destroy
  has_many :tools, class_name: "MaintenanceTool", dependent: :destroy
  has_many_attached :images
  has_many :comments, -> { visible.order(:created_at) }, dependent: :destroy
  has_many :favorites, dependent: :destroy

  enum :work_difficulty, { easy: 0, normal: 1, hard: 2 }, prefix: :difficulty
  enum :status, { draft: 0, published: 1 }, default: :draft

  accepts_nested_attributes_for :steps, allow_destroy: true,
                                reject_if: ->(attrs) { attrs["title"].blank? && attrs["body"].blank? }
  accepts_nested_attributes_for :tools, allow_destroy: true,
                                reject_if: ->(attrs) { attrs["name"].blank? }

  validates :title, :maintenance_day, :work_difficulty, presence: true
  validates :category, inclusion: { in: CATEGORIES }
  validates :work_time_minutes, :work_cost,
            numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true

  # 公開中で、削除されていない記録だけ
  scope :visible, -> { published.kept.where(user_id: User.active.select(:id)) }
  scope :latest, -> { order(created_at: :desc) }

  # 検索・絞り込み（条件が空のときは何もしない）
  scope :keyword, ->(q) {
    where("maintenances.title LIKE :q OR maintenances.summary LIKE :q", q: "%#{sanitize_sql_like(q)}%") if q.present?
  }
  scope :by_category, ->(category) { where(category: category) if category.present? }
  scope :by_difficulty, ->(difficulty) {
    where(work_difficulty: difficulty) if difficulty.present? && work_difficulties.key?(difficulty)
  }
  scope :by_maker, ->(maker) { joins(:car).where(cars: { manufacturer_name: maker }) if maker.present? }

  # 並び替え（値が入っていない記録は後ろに回す）
  scope :sorted, ->(key) {
    case key
    when "popular" then order(favorites_count: :desc, created_at: :desc)
    when "cost" then order(Arel.sql("maintenances.work_cost IS NULL, maintenances.work_cost ASC"))
    when "time" then order(Arel.sql("maintenances.work_time_minutes IS NULL, maintenances.work_time_minutes ASC"))
    else latest
    end
  }

  
  validate :car_must_belong_to_user

  def favorited_by?(user)
    user.present? && favorites.exists?(user_id: user.id)
  end

  private

  # 他人の車を選べないようにする
  def car_must_belong_to_user
    return if car.blank? || car.user_id == user_id
    errors.add(:car, "は自分の車を選んでください")
  end
end