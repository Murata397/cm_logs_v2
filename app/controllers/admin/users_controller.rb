class Admin::UsersController < Admin::BaseController
  before_action :set_user, only: [ :show, :destroy, :restore ]

  def index
    @users = filter_by_status(User)
    if params[:q].present?
      q = "%#{User.sanitize_sql_like(params[:q])}%"
      @users = @users.where("users.name LIKE :q OR users.email LIKE :q", q: q)
    end
    @users = @users.order(created_at: :desc).limit(100)
  end

  def show
    @maintenances = @user.maintenances.order(created_at: :desc)
    @groups = @user.owned_groups.order(created_at: :desc)
    @comments = @user.comments.includes(:maintenance).order(created_at: :desc).limit(20)
  end

  # 退会させる（データは残す）
  def destroy
    if @user.guest?
      back_to admin_users_path, "ゲストユーザーは退会させられません"
    else
      @user.soft_delete!
      back_to admin_users_path, "#{@user.name}さんを退会させました"
    end
  end

  def restore
    @user.restore!
    back_to admin_users_path, "#{@user.name}さんを復元しました"
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
end
