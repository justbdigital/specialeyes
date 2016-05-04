class ReviewsController < ApplicationController
  before_action :authenticate_user!

  def new
    authorize Review
    params[:booking] ? booking_and_venue : @venue = Venue.find_by(name: params[:venue])
  end

  def create
    authorize Review
    @review = Review.new(review_params.merge(consumer: current_user, venue_id: params[:venue], booking_id: params[:booking]))
    if @review.save
      redirect_to venue_url(@review.venue), notice: 'Review Created'
    else
      redirect_to new_review_url, notice: @review.errors.full_messages.join(', ')
    end
  end

  private

  def booking_and_venue
    @booking = Booking.find(params[:booking])
    @venue = @booking.pro.venue
  end

  def review_params
    params.require(:review).permit(:ambiance, :cleanliness, :staff, :comment, :value)
  end
end
