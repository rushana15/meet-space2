class Event < ApplicationRecord
  belongs_to :user
  belongs_to :booking
  has_many :event_bookings, dependent: :destroy
  has_many_attached :photos
end
