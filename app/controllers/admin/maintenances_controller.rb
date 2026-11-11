class Admin::MaintenancesController < Admin::BaseController
  before_action :set_record, only: [:destroy, :restore]

  def index
    @records = filter_by_status(Maintenance).includes(:user, :car)
    if params[:q].present?
      @records = @records.where("maintenances.title LIKE ?", "%#{Maintenance.sanitize_sql_like(params[:q])}%")
    end
    @records = @records.order(created_at: :desc).limit(100)
  end

  def destroy
    @record.soft_delete!
    back_to admin_maintenances_path, "整備記録を削除しました"
  end

  def restore
    @record.restore!
    back_to admin_maintenances_path, "整備記録を復元しました"
  end

  private

  def set_record
    @record = Maintenance.find(params[:id])
  end
end
