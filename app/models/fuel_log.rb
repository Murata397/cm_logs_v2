class FuelLog < ApplicationRecord
  belongs_to :car

  FUEL_TYPES = %w[レギュラー ハイオク 軽油].freeze

  validates :refueled_on, :trip_distance, :fuel_amount, presence: true
  validates :trip_distance, :fuel_amount, numericality: { greater_than: 0 }

  # 燃費（km/L）
  def efficiency
    (trip_distance / fuel_amount).round(1)
  end
end