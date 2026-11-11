class CarsController < ApplicationController
  before_action :authenticate_user!, except: [ :show ]
  before_action :reject_guest_user, except: [ :index, :show ]
  before_action :set_car, only: [ :edit, :update, :destroy ]

  def index
    @cars = current_user.cars
                        .with_attached_image
                        .includes(:inspection_schedules, :fuel_logs)
                        .order(:created_at)
  end

  # 車の詳細（だれでも見られる。持ち主には管理用のメニューも出す）
  def show
    @car = Car.joins(:user).merge(User.active)
              .with_attached_image
              .includes(:user, :inspection_schedules, :fuel_logs)
              .find(params[:id])
    @owner = user_signed_in? && @car.user_id == current_user.id
    @maintenances = @car.maintenances.visible.latest.includes(:user, :car, images_attachments: :blob)
    @schedules = @car.inspection_schedules.sort_by { |s| [ s.next_due_on ? 0 : 1, s.next_due_on || Date.current ] } if @owner
  end

  def new
    @car = current_user.cars.build
  end

  def create
    @car = current_user.cars.build(car_params)
    if @car.save
      redirect_to cars_path, notice: "車を登録しました"
    else
      render :new, status: :unprocessable_content
    end
  end

  def edit
  end

  def update
    if @car.update(car_params)
      redirect_to cars_path, notice: "車の情報を更新しました"
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @car.destroy
    redirect_to cars_path, notice: "車を削除しました", status: :see_other
  end

  private

  def set_car
    @car = current_user.cars.find(params[:id])
  end

  def car_params
    params.expect(car: [ :car_name, :manufacturer_name, :car_model, :odometer, :purpose, :image ])
  end
end
