class MaintenanceTool < ApplicationRecord
  belongs_to :maintenance
  has_one_attached :image

  validates :name, presence: true
end