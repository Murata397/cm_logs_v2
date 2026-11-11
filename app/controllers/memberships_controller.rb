# 自分の参加申請・申請の取り消し・グループからの退出
class MembershipsController < ApplicationController
  before_action :authenticate_user!
  before_action :reject_guest_user
  before_action :set_group

  def create
    membership = @group.group_users.find_or_initialize_by(user: current_user)
    if membership.new_record?
      membership.save!
      redirect_to @group, notice: "参加を申請しました。オーナーの承認をお待ちください"
    else
      redirect_to @group, alert: "すでに申請済みか、参加しています"
    end
  end

  def destroy
    if @group.owned_by?(current_user)
      redirect_to @group, alert: "オーナーはグループから抜けられません。グループを削除してください"
      return
    end

    membership = @group.group_users.find_by!(user: current_user)
    message = membership.pending? ? "参加申請を取り消しました" : "グループから退出しました"
    membership.destroy
    redirect_to @group, notice: message, status: :see_other
  end

  private

  def set_group
    @group = Group.active.find(params[:group_id])
  end
end
