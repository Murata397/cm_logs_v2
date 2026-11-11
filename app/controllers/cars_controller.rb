class CarsController < ApplicationController
  before_action :authenticate_user!
  before_action :reject_guest_user, except: [:index]
  before_action :set_car, only: [:edit, :update, :destroy]

  def index
    @cars = current_user.cars.with_attached_image.order(:created_at)
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
    params.expect(car: [:car_name, :manufacturer_name, :car_model, :odometer, :purpose, :image])
  end
end