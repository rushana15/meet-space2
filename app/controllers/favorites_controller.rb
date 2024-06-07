class FavoritesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_venue, only: [:create, :destroy]

  def index
    @favorites = policy_scope(current_user.favorites.includes(:venue))
    authorize @favorites
  end

  def create

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
