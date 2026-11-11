class MypagesController < ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user
    @cars = @user.cars.includes(:fuel_logs, :inspection_schedules).order(:created_at)

    # これからの点検（日付が近い順。距離だけで決めた予定は後ろ）
    @upcoming = InspectionSchedule.joins(:car)
                                  .where(cars: { user_id: @user.id })
                                  .where("next_due_on IS NULL OR next_due_on >= ?", Date.current)
                                  .includes(:car)
                                  .order(Arel.sql("next_due_on IS NULL, next_due_on"))
                                  .limit(5)

    @maintenances = @user.maintenances.where(deleted_at: nil).includes(:car).latest.limit(10)
    @groups = @user.groups.active.order(:name)
    @favorites = @user.favorite_maintenances.visible.includes(:car).latest.limit(5)
  end
end
