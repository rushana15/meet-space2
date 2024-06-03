class FavoritesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_venue


  def index
    @favorites = current_user.favorites.includes(:venue)
  end

  def create
    @venue = Venue.find(params[:venue_id])
    @favorite = current_user.favorites.build(venue: @venue)
    authorize @favorite

    if @favorite.save
      redirect_to @venue, notice: 'Venue was successfully added to your favorites.'
    else
      redirect_to @venue, alert: 'Unable to add venue to favorites.'
    end
  end

  def destroy
    @favorite = current_user.favorites.find(params[:id])
    authorize @favorite
    if @favorite.destroy
      redirect_to @venue, notice: 'Venue was successfully removed from your favorites.'
    else
      redirect_to @venue, alert: 'Unable to remove venue from favorites.'
    end
  end

  private

  def set_venue
    @venue = Venue.find(params[:venue_id])
  end
end
