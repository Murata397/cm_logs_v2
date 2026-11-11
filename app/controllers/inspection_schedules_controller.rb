class InspectionSchedulesController < ApplicationController
  before_action :authenticate_user!
  before_action :reject_guest_user
  before_action :set_car
  before_action :set_schedule, only: [ :edit, :update, :destroy ]

  def new
    @schedule = @car.inspection_schedules.build
  end

  def create
    @schedule = @car.inspection_schedules.build(schedule_params)
    if @schedule.save
      redirect_to cars_path, notice: "点検の予定を登録しました"
    else
      render :new, status: :unprocessable_content
    end
  end

  def edit
  end

  def update
    if @schedule.update(schedule_params)
      redirect_to cars_path, notice: "点検の予定を更新しました"
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @schedule.destroy
    redirect_to cars_path, notice: "点検の予定を削除しました", status: :see_other
  end

  private

  def set_car
    @car = current_user.cars.find(params[:car_id])
  end

  def set_schedule
    @schedule = @car.inspection_schedules.find(params[:id])
  end

  def schedule_params
    params.expect(inspection_schedule: [ :item, :next_due_on, :next_due_odometer ])
  end
end
