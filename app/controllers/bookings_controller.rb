class BookingsController < ApplicationController


  before_action :set_venue, only: [:create, :show]
  before_action :set_booking, only: [:destroy, :confirm]
  before_action :authenticate_user!


  def new
    @booking = Booking.new
    @venue = Venue.find(params[:venue_id])
  end

  def create
    @venue = Venue.find(params[:venue_id])
    @booking = @venue.bookings.new(booking_params)
    @booking.user = current_user
    authorize @booking

    if @booking.save
      redirect_to profile_path(current_user), notice: "Your request has been sent!  Awaiting confirmation."
    else
      render :new

    end
  end

  def show
    authorize @booking
  end

  def confirm
    authorize @booking
    if @booking.update(confirmed: true)
      redirect_to profile_path(current_user), notice: 'Booking was successfully confirmed.'
    else
      redirect_to profile_path(current_user), alert: 'Unable to confirm booking.'
    end

  end


  def destroy
    # @booking = Booking.find(params[:id])
    authorize @booking
    @booking.destroy
    redirect_to profile_path, notice: 'Booking was successfully destroyed.'
  end

  private

  def set_venue
    @venue = Venue.find(params[:venue_id])
  end

  def set_booking
    @booking = Booking.find(params[:id])
  end

  def booking_params
    params.require(:booking).permit(:booking_date, :comment, :start_time, :end_time)
  end

end
