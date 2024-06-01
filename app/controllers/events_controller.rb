class EventsController < ApplicationController
  before_action :set_event, only: %i[show]
  skip_before_action :authenticate_user!, only: %i[index show]



  def index
    @events = Event.all
    authorize @events
  end

  def show
    authorize @event
  end

  def new
    @event = Event.new
    @booking = Booking.find(params[:booking_id])
    authorize @event
  end

  def create
    @event = Event.new(event_params)
    @event.user = current_user
    authorize @event
    @booking = Booking.find(params[:booking_id])
    @event.booking = @booking
    if @event.save
      redirect_to event_path(@event), notice: "You have made a new event."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private
def set_event
  @event = Event.find(params[:id])
end
def event_params
  params.require(:event).permit(:title, :description, :ticket_price, :reoccuring, photos: [])
end
def authorize_event
  authorize @event
end
end
