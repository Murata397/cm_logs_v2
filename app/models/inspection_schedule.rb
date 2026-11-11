class InspectionSchedule < ApplicationRecord
  belongs_to :car

  validates :item, presence: true
  validate :due_must_be_present

  # 次の点検まであと何日か
  def days_left
    return nil if next_due_on.blank?
    (next_due_on - Date.current).to_i
  end

  # 次の点検まであと何km か
  def km_left
    return nil if next_due_odometer.blank? || car.odometer.blank?
    next_due_odometer - car.odometer
  end

  private

  def due_must_be_present
    return if next_due_on.present? || next_due_odometer.present?
    errors.add(:base, "次回の予定日か走行距離のどちらかを入力してください")
  end
end
