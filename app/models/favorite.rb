class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :maintenance, counter_cache: true

  validates :user_id, uniqueness: { scope: :maintenance_id }
end
