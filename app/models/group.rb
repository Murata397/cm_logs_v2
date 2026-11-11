class Group < ApplicationRecord
  include ImageValidatable

  belongs_to :owner, class_name: "User"
  has_one_attached :image
  has_many :group_users, dependent: :destroy
  has_many :member_group_users, -> { approved }, class_name: "GroupUser"
  has_many :members, through: :member_group_users, source: :user
  has_many :pending_group_users, -> { pending }, class_name: "GroupUser"

  validates :name, presence: true, length: { maximum: 30 }
  validates :introduction, presence: true, length: { maximum: 200 }
  validates :theme, length: { maximum: 30 }
  validates :rules, length: { maximum: 500 }
  validates_image :image

  # 作った人は、最初からメンバーにする
  after_create { group_users.create!(user: owner, status: :approved) }

  scope :active, -> { where(deleted_at: nil) }
  scope :latest, -> { order(created_at: :desc) }
  scope :keyword, ->(q) {
    where("groups.name LIKE :q OR groups.introduction LIKE :q OR groups.theme LIKE :q", q: "%#{sanitize_sql_like(q)}%") if q.present?
  }

  def owned_by?(user)
    user.present? && owner_id == user.id
  end

  # そのユーザーの参加状況（nil：未参加 / "pending"：申請中 / "approved"：メンバー）
  def status_for(user)
    return nil if user.blank?
    group_users.find_by(user_id: user.id)&.status
  end
end
