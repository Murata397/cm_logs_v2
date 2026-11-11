class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one_attached :profile_image
  has_many :cars, dependent: :destroy
  has_many :maintenances, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorite_maintenances, through: :favorites, source: :maintenance

  validates :name, presence: true, length: { maximum: 30 }
  validates :introduction, length: { maximum: 300 }
  validate :profile_image_must_be_valid

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

  private

  # 画像以外のファイルや、大きすぎる画像を弾く
  def profile_image_must_be_valid
    return unless profile_image.attached?

    unless profile_image.content_type.in?(%w[image/jpeg image/png image/webp image/gif])
      errors.add(:profile_image, "は画像ファイル（JPEG・PNG・WebP・GIF）を選んでください")
    end
    if profile_image.byte_size > 5.megabytes
      errors.add(:profile_image, "は5MB以下にしてください")
    end
  end
end