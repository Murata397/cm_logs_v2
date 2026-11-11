class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :reject_guest_user
  before_action :set_maintenance

  def create
    @comment = @maintenance.comments.build(comment_params.merge(user: current_user))

    if @comment.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to maintenance_path(@maintenance) }
      end
    else
      render turbo_stream: turbo_stream.replace(
        "comment_form",
        partial: "comments/form",
        locals: { maintenance: @maintenance, comment: @comment }
      ), status: :unprocessable_content
    end
  end

  def destroy
    @comment = @maintenance.comments.where(user: current_user).find(params[:id])
    @comment.destroy

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to maintenance_path(@maintenance), status: :see_other }
    end
  end

  private

  def set_maintenance
    @maintenance = Maintenance.visible.find(params[:maintenance_id])
  end

  def comment_params
    params.expect(comment: [ :body ])
  end
end
