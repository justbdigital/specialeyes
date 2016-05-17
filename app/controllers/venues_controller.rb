class VenuesController < ApplicationController
  before_action :authenticate_user!, except: [:show, :index]
  before_action :set_venue, only: [:show, :update, :edit]
  before_action :set_hash, only: [:show, :edit]

  impressionist actions: [:show]

  def index
    @venues = ::Venues::Finder.new(params).call.paginate(page: params[:page], per_page: 3)
  end

  def new
    authorize Venue
    @venue = Venue.new
  end

  def edit
    authorize @venue
    @venue = current_user.venue
  end

  def show
    impressionist(@venue)
    @treatments_with_groups = Treatment.where(pro: @venue.pro).group_by(&:treatment_group)
    @reviews = Review.where(venue: @venue).paginate(page: params[:page], per_page: 3)
  end

  def create
    @venue = Venue.new(venue_params.merge(pro: current_user))
    authorize @venue
    if @venue.save
      redirect_to edit_venue_url(@venue), notice: 'Venue Created'
    else
      redirect_to new_venue_url, notice: @venue.errors.full_messages.join(', ')
    end
  end

  def update
    authorize @venue
    if @venue.update(venue_params)

      redirect_to edit_venue_url(@venue), notice: 'Venue Updated'
    else
      redirect_to edit_venue_url(@venue), notice: @venue.errors.full_messages.join(', ')
    end
  end

  private

  def set_hash
    @hash ||= set_address unless @venue.address.blank?
  end

  def set_venue
    @venue = Venue.find_by_name(params[:id])
  end

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
