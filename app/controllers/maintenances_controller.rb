class MaintenancesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :reject_guest_user, except: [:index, :show]
  before_action :set_own_maintenance, only: [:edit, :update, :destroy]

  def index
    @maintenances = Maintenance.visible.latest.includes(:user, :car, images_attachments: :blob)
    @maintenances = @maintenances.where(category: params[:category]) if params[:category].present?
  end

  def show
    @maintenance = Maintenance.visible
                              .includes(:user, :car, :tools, steps: { image_attachment: :blob })
                              .find(params[:id])

    @related = Maintenance.visible
                          .joins(:car)
                          .where(cars: { car_model: @maintenance.car.car_model })
                          .where.not(id: @maintenance.id)
                          .includes(:car)
                          .latest
                          .limit(3)
  end

  def new
    if current_user.cars.empty?
      redirect_to new_car_path, alert: "整備記録を投稿する前に、車を登録してください"
      return
    end

    @maintenance = current_user.maintenances.build(maintenance_day: Date.current, work_difficulty: :normal)
    @maintenance.steps.build
    @maintenance.tools.build
  end

  def create
    @maintenance = current_user.maintenances.build(maintenance_params)
    if @maintenance.save
      redirect_to after_save_path, notice: saved_message
    else
      render :new, status: :unprocessable_content
    end
  end

  def edit
  end

  def update
    if @maintenance.update(maintenance_params_for_update)
      redirect_to after_save_path, notice: saved_message
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @maintenance.update!(deleted_at: Time.current)
    redirect_to maintenances_path, notice: "整備記録を削除しました", status: :see_other
  end

  private

  def set_own_maintenance
    @maintenance = current_user.maintenances.where(deleted_at: nil).find(params[:id])
  end

  def maintenance_params
    params.require(:maintenance).permit(
      :car_id, :title, :maintenance_day, :category, :work_difficulty,
      :work_time_minutes, :work_cost, :summary, :related_information, :status,
      images: [],
      steps_attributes: [:id, :position, :title, :body, :_destroy],
      tools_attributes: [:id, :name, :_destroy]
    )
  end

  # 編集で画像を選ばなかったときに、今の画像が消えないようにする
  def maintenance_params_for_update
    attrs = maintenance_params
    attrs.delete(:images) if Array(attrs[:images]).compact_blank.empty?
    attrs
  end

  # 公開なら詳細ページへ、下書きなら編集画面へ
  def after_save_path
    @maintenance.published? ? maintenance_path(@maintenance) : edit_maintenance_path(@maintenance)
  end

  def saved_message
    @maintenance.published? ? "整備記録を公開しました" : "下書きを保存しました"
  end
end