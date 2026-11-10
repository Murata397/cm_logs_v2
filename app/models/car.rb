class Car < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  has_many :maintenances, dependent: :destroy
  has_many :fuel_logs, dependent: :destroy
  has_many :inspection_schedules, dependent: :destroy

  validates :manufacturer_name, :car_model, :car_name, presence: true
  validates :odometer, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true

  # 今日以降で一番近い点検の予定
  def next_inspection
    inspection_schedules.where("next_due_on >= ?", Date.current).order(:next_due_on).first
  end
end