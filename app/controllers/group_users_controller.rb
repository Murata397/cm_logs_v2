# オーナーによる、参加申請の承認・拒否と、メンバーの削除
class GroupUsersController < ApplicationController
  before_action :authenticate_user!
  before_action :reject_guest_user
  before_action :set_group_user

  # 承認
  def update
    @group_user.approved!
    redirect_to @group, notice: "#{@group_user.user.name}さんの参加を承認しました"
  end

  # 申請の拒否・メンバーの削除
  def destroy
    if @group_user.user_id == @group.owner_id
      redirect_to @group, alert: "オーナーは削除できません"
      return
    end

    message = @group_user.pending? ? "参加申請を見送りました" : "#{@group_user.user.name}さんをメンバーから外しました"
    @group_user.destroy
    redirect_to @group, notice: message, status: :see_other
  end

  private

  # 自分がオーナーのグループの中からだけ探す（他人のグループは触れない）
  def set_group_user
    @group = current_user.owned_groups.active.find(params[:group_id])
    @group_user = @group.group_users.find(params[:id])
  end
end
