class FavoritesController < ApplicationController
  before_action :authenticate_user!
  before_action :reject_guest_user
  before_action :set_maintenance

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
