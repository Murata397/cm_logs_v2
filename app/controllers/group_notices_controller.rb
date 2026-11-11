# オーナーが、メンバーにお知らせを送る
class GroupNoticesController < ApplicationController
  before_action :authenticate_user!
  before_action :reject_guest_user
  before_action :set_group

  def new
    @notice = @group.notices.build(user: current_user)
  end

  def create
    @notice = @group.notices.build(notice_params.merge(user: current_user))
    if @notice.save
      @notice.deliver_to_members
      redirect_to @group, notice: "お知らせを送信しました（#{@notice.recipients.count}人）"
    else
      render :new, status: :unprocessable_content
    end
  end

  private

  # 自分がオーナーのグループだけ
  def set_group
    @group = current_user.owned_groups.active.find(params[:group_id])
  end

  def notice_params
    params.expect(group_notice: [ :title, :body ])
  end
end
