class FuelLogsController < ApplicationController
  before_action :authenticate_user!
  before_action :reject_guest_user
  before_action :set_car

  def new
    @fuel_log = @car.fuel_logs.build(refueled_on: Date.current, fuel_type: "レギュラー")
  end

  def create
    @fuel_log = @car.fuel_logs.build(fuel_log_params)
    if @fuel_log.save
      # 給油時の走行距離が入っていたら、車の走行距離も更新しておく
      @car.update(odometer: @fuel_log.odometer) if @fuel_log.odometer.present?
      redirect_to cars_path, notice: "給油を記録しました（燃費 #{@fuel_log.efficiency} km/L）"
    else
      render :new, status: :unprocessable_content
    end
  end

  def destroy
    @car.fuel_logs.find(params[:id]).destroy
    redirect_to cars_path, notice: "給油の記録を削除しました", status: :see_other
  end

  private

  def set_car
    @car = current_user.cars.find(params[:car_id])
  end

  def fuel_log_params
    params.expect(fuel_log: [:refueled_on, :odometer, :trip_distance, :fuel_amount, :fuel_type])
  end
end
