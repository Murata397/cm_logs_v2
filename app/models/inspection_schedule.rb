class InspectionSchedule < ApplicationRecord
  belongs_to :car

  validates :item, presence: true

  # 次の点検まであと何日か
  def days_left
    return nil if next_due_on.blank?
    (next_due_on - Date.current).to_i
  end
end