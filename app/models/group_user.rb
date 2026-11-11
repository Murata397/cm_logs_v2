class GroupUser < ApplicationRecord
  belongs_to :group
  belongs_to :user

  enum :status, { pending: 0, approved: 1 }

  validates :user_id, uniqueness: { scope: :group_id }
end
