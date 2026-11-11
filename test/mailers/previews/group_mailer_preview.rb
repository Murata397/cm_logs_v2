# http://localhost:3000/rails/mailers/group_mailer/notice でメールの見た目を確認できる
class GroupMailerPreview < ActionMailer::Preview
  def notice
    notice = GroupNotice.last || GroupNotice.new(
      group: Group.first || Group.new(name: "見本のグループ"),
      user: User.first,
      title: "次回のオフ会について",
      body: "来月の第2日曜に、洗車オフ会をします。\n参加できる人はコメントください。"
    )
    GroupMailer.with(notice: notice, recipient: User.first).notice
  end
end
