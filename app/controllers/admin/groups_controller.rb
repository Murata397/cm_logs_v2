class Admin::GroupsController < Admin::BaseController
  before_action :set_record, only: [:destroy, :restore]

  def index
    @records = filter_by_status(Group).includes(:owner)
    if params[:q].present?
      @records = @records.where("groups.name LIKE ?", "%#{Group.sanitize_sql_like(params[:q])}%")
    end
    @records = @records.order(created_at: :desc).limit(100)
  end

  def destroy
    @record.soft_delete!
    back_to admin_groups_path, "グループを削除しました"
  end

  def restore
    @record.restore!
    back_to admin_groups_path, "グループを復元しました"
  end

  private

  def set_record
    @record = Group.find(params[:id])
  end
end
