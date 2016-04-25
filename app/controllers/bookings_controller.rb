class BookingsController < ApplicationController
  before_action :authenticate_user!, only: [:new]
  before_action :set_treatment, only: [:create]

  def index
  end

  def new
    @date = params[:date] ? Date.parse(params[:date]) : Time.zone.now.to_date
    @am_available = BookingService.new(@date, params[:treat]).am_slots
    @pm_available = BookingService.new(@date, params[:treat]).pm_slots
  end

  def create
    if DateTime.parse(params[:date]) <= Time.zone.now
      redirect_to :back, notice: 'Date is in the past'
    elsif current_user.is_a? Pro
      redirect_to :back, notice: 'You should be signed in as consumer'
    elsif current_user.is_a? Consumer
      @booking = Booking.new(consumer: current_user,
                             pro: @treatment.pro,
                             treatment: @treatment,
                             sum: @treatment.sale_price,
                             start_at: booking_start_at)
      authorize @booking
      (redirect_to new_transaction_url(treat: params[:treat]), notice: 'Booking Created') if @booking.save
    else
      redirect_to :back, notice: 'Something was wrong'
    end
  end

  private

  def booking_start_at
    @datetime ||= DateTime.parse(params[:date]) + (params[:time].to_i * 30).minutes
  end

  def set_treatment
    @treatment ||= Treatment.find(params[:treat])
  end
end
