class FavoritesController < ApplicationController
  before_action :authenticate_user!
  before_action :reject_guest_user, except: [:index]
  before_action :set_maintenance, except: [:index]

  # 自分がお気に入りした整備記録（お気に入りした順）
  def index
    @maintenances = current_user.favorite_maintenances
                                .visible
                                .includes(:user, :car, images_attachments: :blob)
                                .order("favorites.created_at DESC")
  end

  def create
    current_user.favorites.find_or_create_by!(maintenance: @maintenance)
    render_button
  end

  def destroy
    current_user.favorites.where(maintenance: @maintenance).destroy_all
    render_button
  end

  private

  def set_maintenance
    @maintenance = Maintenance.visible.find(params[:maintenance_id])
  end

  # お気に入りボタンの部分だけを書き換える
  def render_button
    @maintenance.reload
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          helpers.dom_id(@maintenance, :favorite),
          partial: "favorites/button",
          locals: { maintenance: @maintenance }
        )
      end
      format.html { redirect_to maintenance_path(@maintenance) }
    end
  end
end
