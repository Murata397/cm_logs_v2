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

  # 平均燃費（全部の走行距離 ÷ 全部の給油量）
  def average_efficiency
    total_fuel = fuel_logs.to_a.sum(&:fuel_amount)
    return nil if total_fuel.zero?

    (fuel_logs.to_a.sum(&:trip_distance) / total_fuel).round(1)
  end

  # グラフ用：古い順に最新10件
  def recent_fuel_logs
    fuel_logs.sort_by(&:refueled_on).last(10)
  end
end
