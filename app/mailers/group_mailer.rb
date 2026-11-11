class GroupMailer < ApplicationMailer
  # グループのお知らせを、メンバー1人に送る
  def notice
    @notice = params[:notice]
    @recipient = params[:recipient]
    @group = @notice.group

    mail to: @recipient.email, subject: "【#{@group.name}】#{@notice.title}"
  end
end
