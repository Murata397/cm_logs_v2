class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :maintenance

  validates :body, presence: true, length: { maximum: 500 }
end
