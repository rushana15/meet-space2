class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :venue
  has_many :events

  has_one :chatroom, dependent: :destroy
  validates :comment, :booking_date, :start_time, :end_time, presence: true
  # validates :booking_date, comparison: { greater_than: Date.today }
  validates :end_time, comparison: { greater_than: :start_time }
  validates :comment, length: { minimum: 10, too_short: "Please provide more information about your event." }

  # before_destroy :destroy_chatroom
  after_create :create_chatroom_with_initial_message
  #before_destroy :destroy_chatroom
  private

  def create_chatroom_with_initial_message
    chatroom = Chatroom.create!(
      name: "Chatroom for Booking #{id}",
      booking: self
    )

    # Create an initial message to establish the relationship between users and chatroom
    Message.create!(
      content: "#{comment}  #{id}",
      user: user, # Booking user
      chatroom: chatroom
    )

    Message.create!(
      content: "Thank you for making a request to book this venue.  The host will be in touch shortly.",
      user: venue.user, # Venue owner
      chatroom: chatroom
    )
  end

end
