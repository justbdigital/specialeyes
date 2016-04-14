class VenuesController < ApplicationController
  def new
    @venue = Venue.new
  end

  def edit
    @venue = current_user.venue
    @hash = set_address unless @venue.address.blank?
  end

  def create
    @venue = Venue.new(venue_params)
    if @venue.save && @venue.update(pro: current_user)
      redirect_to edit_venue_url, notice: 'Venue Created'
    else
      redirect_to :back, notice: @event.errors.full_messages.join(', ')
    end
  end

  def update
    @venue = Venue.find(params[:id])
    if @venue.pro == current_user && @venue.update(venue_params)
      redirect_to edit_venue_url, notice: 'Venue Updated'
    else
      redirect_to :back, notice: @team.errors.full_messages.join(', ')
    end
  end

  private

  def set_address
    Gmaps4rails.build_markers([@venue]) do |venue, marker|
      marker.lat venue.latitude
      marker.lng venue.longitude
      marker.infowindow '<b>#{venue.name}</b>'
    end
  end

  def venue_params
    params.require(:venue).permit(:name, :description, :primary_type, :address, :image, :remote_image_url, :remove_image, :phone, :email)
  end
end
