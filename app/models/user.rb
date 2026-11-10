class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one_attached :profile_image
  has_many :cars, dependent: :destroy
  has_many :maintenances, dependent: :destroy

  validates :name, presence: true, length: { maximum: 30 }

  # 退会していないユーザーだけ
  scope :active, -> { where(deleted_at: nil) }
end