class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: :home
  require 'date'

  def home

  end

  def profile
    @user = current_user
    @venues = @user.venues
    @bookings = current_user.bookings.order(created_at: :desc)
    @chatrooms = current_user.chatrooms
    @requests = current_user.venues.flat_map { |venue| venue.bookings }.sort_by { |booking| booking.created_at }.reverse
    @favorite_venues = @user.favorites.includes(:venue).map(&:venue)
    # @requests = current_user.venues.map{|venue| venue.bookings}.flatten

    # all of the bookings where the current user owns the venue
    @venue = Venue.last
    @current_bookings = []
    @past_bookings = []
    @bookings.each do |booking|
      if booking.booking_date > Date.today
        @current_bookings << booking
      else
        @past_bookings << booking
      end
    end

    @current_requests = []
    @past_requests = []

    @requests.each do |request|
      if request.booking_date > Date.today
        @current_requests << request
      else
        @past_requests << request
      end
    end


  end
end
