class Venue < ApplicationRecord
  CATEGORIES = %w[NETWORK MEET CELEBRATE]

  belongs_to :user
  has_many :bookings, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many_attached :photos, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorited_by_users, through: :favorites, source: :user
  validates :name, :address, :category, :capacity, presence: true

  validates :category, inclusion: { in: CATEGORIES }

  geocoded_by :address
  after_validation :geocode, if: :will_save_change_to_address?

  include PgSearch::Model
  pg_search_scope :search_by_name_and_facilities,
    against: [ :name, :facilities, :description, :address ],
    using: {
      tsearch: { prefix: true }
    }
end
