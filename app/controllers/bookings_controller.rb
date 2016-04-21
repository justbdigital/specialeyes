class BookingsController < ApplicationController
  before_action :authenticate_user!, only: [:create]
  before_action :set_treatment, only: [:create]

  def new
    @booking = Booking.new
  end

  def create
    @booking = Booking.new(booking_params.merge(consumer: current_user, pro: @treatment.pro))
    authorize @booking
    if @booking.save
      redirect_to new_transaction_url, notice: 'Booking Created'
    else
      redirect_to :back, notice: @booking.errors.full_messages.join(', ')
    end
  end

  private

  def set_treatment
    @treatment ||= Treatment.find(params[:treatment_id])
  end

  def booking_params
    params.require(:booking).permit(:start_at)
  end
end
