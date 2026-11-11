class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one_attached :profile_image
  has_many :cars, dependent: :destroy
  has_many :maintenances, dependent: :destroy

  validates :name, presence: true, length: { maximum: 30 }

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
end