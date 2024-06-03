class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :venue

  validates :user_id, uniqueness: { scope: :venue_id }
end
