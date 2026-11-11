class GroupNotice < ApplicationRecord
  belongs_to :group
  belongs_to :user

  validates :title, presence: true, length: { maximum: 50 }
  validates :body, presence: true, length: { maximum: 1000 }

  # お知らせメールを送る相手（送った本人とゲストは除く）
  def recipients
    group.members.where.not(id: user_id).where.not(email: User::GUEST_EMAIL)
  end

  # メンバー1人ずつに、別々のメールで送る（ほかの人のアドレスが見えないように）
  def deliver_to_members
    recipients.find_each do |member|
      GroupMailer.with(notice: self, recipient: member).notice.deliver_later
    end
  end
end
