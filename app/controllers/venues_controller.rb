class VenuesController < ApplicationController
  before_action :set_venue, only: %i[show edit update destroy]
  skip_before_action :authenticate_user!, only: %i[index show]

  def index
    # @venues = Venue.all

    if params[:query].present?
      @venues = Venue.search_by_name_and_facilities(params[:query]).where.not(user: current_user)
    else
      @venues = Venue.where.not(user: current_user)
    end

    policy_scope @venues

    @markers = @venues.map do |venue|
      {
        lat: venue.latitude,
        lng: venue.longitude,
        info_window_html: render_to_string(partial: "info_window", locals: {venue: venue}),
        marker_html: render_to_string(partial: "marker", locals: {venue: venue})
      }
    end

  end

  def show
    authorize @venue
    @review = Review.new
    @reviews = @venue.reviews
    @booking = Booking.new
    @marker = {
      lat: @venue.latitude,
      lng: @venue.longitude,
      info_window_html: render_to_string(partial: "info_window", locals: {venue: @venue}),
      marker_html: render_to_string(partial: "marker", locals: {venue: @venue})
    }
  end

  def new
    @venue = Venue.new
    authorize @venue
  end

  def create
    @venue = Venue.new(venue_params)
    @venue.user = current_user
    authorize @venue
    if @venue.save
      redirect_to @venue, notice: "Venue has been sucessfully added to your porfolio."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @venue
  end

  def update
    authorize @venue
    if @venue.update(venue_params)
      redirect_to @venue
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @venue
    @venue.destroy
    redirect_to profile_path(current_user)
  end

  def category
    # @category = params[:category]
    @venues = Venue.where(category: params[:category]).where.not(user: current_user)
    authorize @venues
    if params[:query].present?
      sql_subquery = "name ILIKE :query OR facilities ILIKE :query OR address ILIKE :query"
      @venues = @venues.where(sql_subquery, query: "%#{params[:query]}%")
    end

    # if params[:query].present?
    #   @venues = @venues.search_by_name_and_facilities(params[:query])
    # end

    @markers = @venues.map do |venue|
      {
        lat: venue.latitude,
        lng: venue.longitude,
        info_window_html: render_to_string(partial: "info_window", locals: {venue: venue}),
        marker_html: render_to_string(partial: "marker", locals: {venue: venue})
      }
    end
    render :index

  end

  private

  def set_venue
    @venue = Venue.find(params[:id])
  end

  def venue_paramsc
    params.require(:venue).permit(:name, :address, :capacity, :facilities, :category, :description, photos: [])
  end
  def authorize_venue
    authorize @venue
  end
end
