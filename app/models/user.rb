class User < ApplicationRecord
  include ImageValidatable
  include SoftDeletable

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one_attached :profile_image
  has_many :cars, dependent: :destroy
  has_many :maintenances, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorite_maintenances, through: :favorites, source: :maintenance
  has_many :group_users, dependent: :destroy
  has_many :joined_group_users, -> { approved }, class_name: "GroupUser"
  has_many :groups, through: :joined_group_users
  has_many :owned_groups, class_name: "Group", foreign_key: :owner_id, dependent: :destroy

  validates :name, presence: true, length: { maximum: 30 }
  validates :introduction, length: { maximum: 300 }
  validates_image :profile_image

  # 退会していないユーザーだけ
  scope :active, -> { where(deleted_at: nil) }

  GUEST_EMAIL = "guest@example.com".freeze

  # ゲストユーザーを探す（いなければ作る）
  def self.guest
    find_or_create_by!(email: GUEST_EMAIL) do |user|
      user.name = "ゲストユーザー"
      user.password = SecureRandom.urlsafe_base64
    end
  end

  def guest?
    email == GUEST_EMAIL
  end

  # 退会した人はログインできないようにする（Deviseが毎回確認する）
  def active_for_authentication?
    super && !deleted?
  end

  def inactive_message
    deleted? ? :deleted_account : super
  end
end
