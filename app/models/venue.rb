class Venue < ApplicationRecord
  belongs_to :user
  has_many :bookings, dependent: :destroy
  has_many_attached :photos
  validates :name, presence: true
  validates :address, presence: true
  validates :category, presence: true
  validates :capacity, presence: true

  include PgSearch::Model
  pg_search_scope :search_by_name_and_facilities,
    against: [ :name, :facilities ],
    using: {
      tsearch: { prefix: true } 
    }
end
