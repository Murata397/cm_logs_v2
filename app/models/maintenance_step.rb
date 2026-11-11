class MaintenanceStep < ApplicationRecord
  belongs_to :maintenance
  has_one_attached :image

  validates :title, presence: true
end
