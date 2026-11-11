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
    inspection_schedules
      .select { |s| s.next_due_on.present? && s.next_due_on >= Date.current }
      .min_by(&:next_due_on)
  end

  # 一番新しい給油の記録
  def latest_fuel_log
    fuel_logs.max_by(&:refueled_on)
  end
end