class FuelLogsController < ApplicationController
  before_action :authenticate_user!
  before_action :reject_guest_user, except: [:index]
  before_action :set_car
  before_action :set_fuel_log, only: [:edit, :update, :destroy]

  # 車ごとの給油の履歴（新しい順）
  def index
    @fuel_logs = @car.fuel_logs.order(refueled_on: :desc, created_at: :desc)
  end

  def new
    @fuel_log = @car.fuel_logs.build(refueled_on: Date.current, fuel_type: "レギュラー")
  end

  def create
    @fuel_log = @car.fuel_logs.build(fuel_log_params)
    if @fuel_log.save
      update_car_odometer
      redirect_to cars_path, notice: "給油を記録しました（燃費 #{@fuel_log.efficiency} km/L）"
    else
      render :new, status: :unprocessable_content
    end
  end

  def edit
  end

  def update
    if @fuel_log.update(fuel_log_params)
      update_car_odometer
      redirect_to car_fuel_logs_path(@car), notice: "給油の記録を更新しました（燃費 #{@fuel_log.efficiency} km/L）"
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @fuel_log.destroy
    redirect_to car_fuel_logs_path(@car), notice: "給油の記録を削除しました", status: :see_other
  end

  private

  def set_car
    @car = current_user.cars.find(params[:car_id])
  end

  # その車の給油記録の中から探す（ほかの車の記録は触れない）
  def set_fuel_log
    @fuel_log = @car.fuel_logs.find(params[:id])
  end

  def fuel_log_params
    params.expect(fuel_log: [:refueled_on, :odometer, :trip_distance, :fuel_amount, :fuel_type])
  end

  # 給油時の走行距離が、今の車の走行距離より大きいときだけ更新する
  # （昔の給油を登録・編集したときに、走行距離が減ってしまわないように）
  def update_car_odometer
    odometer = @fuel_log.odometer
    return if odometer.blank?
    return if @car.odometer.present? && odometer <= @car.odometer

    @car.update(odometer: odometer)
  end
end
