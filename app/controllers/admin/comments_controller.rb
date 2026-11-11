class Admin::CommentsController < Admin::BaseController
  before_action :set_record, only: [ :destroy, :restore ]

  def index
    @records = filter_by_status(Comment).includes(:user, :maintenance)
    if params[:q].present?
      @records = @records.where("comments.body LIKE ?", "%#{Comment.sanitize_sql_like(params[:q])}%")
    end
    @records = @records.order(created_at: :desc).limit(100)
  end

  def destroy
    @record.soft_delete!
    back_to admin_comments_path, "コメントを削除しました"
  end

  def restore
    @record.restore!
    back_to admin_comments_path, "コメントを復元しました"
  end

  private

  def set_record
    @record = Comment.find(params[:id])
  end
end
