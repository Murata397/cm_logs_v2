class GroupsController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :reject_guest_user, except: [:index, :show]
  before_action :set_group, only: [:show, :edit, :update, :destroy]
  before_action :ensure_owner, only: [:edit, :update, :destroy]

  def index
    @groups = Group.active
                   .keyword(params[:q])
                   .latest
                   .with_attached_image
                   .includes(:owner, :member_group_users)
  end

  def show
    @members = @group.member_group_users.includes(:user).order(:created_at)
    @status = @group.status_for(current_user)
    @pending = @group.pending_group_users.includes(:user).order(:created_at) if @group.owned_by?(current_user)
    # お知らせはメンバーだけが見られる
    @notices = @group.notices.includes(:user).limit(5) if @status == "approved"
  end

  def new
    @group = current_user.owned_groups.build
  end

  def create
    @group = current_user.owned_groups.build(group_params)
    if @group.save
      redirect_to @group, notice: "グループを作成しました"
    else
      render :new, status: :unprocessable_content
    end
  end

  def edit
  end

  def update
    if @group.update(group_params)
      redirect_to @group, notice: "グループの情報を更新しました"
    else
      render :edit, status: :unprocessable_content
    end
  end

  # 整備記録と同じく、消さずに「削除した印」をつける（管理画面から戻せるように）
  def destroy
    @group.update!(deleted_at: Time.current)
    redirect_to groups_path, notice: "グループを削除しました", status: :see_other
  end

  private

  def set_group
    @group = Group.active.find(params[:id])
  end

  def ensure_owner
    return if @group.owned_by?(current_user)
    redirect_to @group, alert: "グループのオーナーだけが操作できます"
  end

  def group_params
    params.expect(group: [:name, :introduction, :theme, :rules, :image])
  end
end
