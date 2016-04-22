class BookingsController < ApplicationController
  before_action :authenticate_user!, only: [:create]
  before_action :set_treatment, only: [:create]

  def index
    @events = [{ id: 1, title: "mememe", url: 'http://google.com/', start: Treatment.first.created_at.to_s, :end => "#{Treatment.first.created_at + 1.hour}" }]
    respond_to do |format|
      format.json { render :json => @events }
    end
  end

  def new
    @booking = Booking.new
    # @bookings = Booking.where(pro: Treatment.find(params[:treat]).pro)
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
