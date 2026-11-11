class UsersController < ApplicationController
  # ユーザーのページ（だれでも見られる）
  def show
    @user = User.active.find(params[:id])
    @cars = @user.cars.with_attached_image.order(:created_at)
    @maintenances = @user.maintenances.visible.latest.includes(:user, :car, images_attachments: :blob)
  end
end
