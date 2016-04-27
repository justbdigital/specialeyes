class BookingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_treatment, only: [:create]
  before_action :set_date, only: [:index, :new]

  def index
    authorize Booking
    @unavailable_by_pro = Bookings::AvailableSlotsFinder.new(@date, nil, current_user).unavailable_by_pro
    @booked_by_customers = Bookings::AvailableSlotsFinder.new(@date, nil, current_user).booked_by_customers
    @pro_am_available = Bookings::AvailableSlotsFinder.new(@date, nil, current_user).am_slots
    @pro_pm_available = Bookings::AvailableSlotsFinder.new(@date, nil, current_user).pm_slots
  end

  def new
    @am_available = Bookings::AvailableSlotsFinder.new(@date, params[:treat]).am_slots
    @pm_available = Bookings::AvailableSlotsFinder.new(@date, params[:treat]).pm_slots
  end

  def create
    if current_user.is_a? Pro
      redirect_to :back, notice: 'You should be signed in as consumer'
    elsif current_user.is_a? Consumer
      @booking = Booking.new(consumer: current_user,
                             pro: @treatment.pro,
                             treatment: @treatment,
                             sum: @treatment.sale_price,
                             start_at: booking_start_at(params[:time]))
      authorize @booking

      if @booking.save
        redirect_to new_transaction_url(treat: params[:treat]), notice: 'Booking Created'
      else
        redirect_to :back, notice: @booking.errors.full_messages.join(', ')
      end
    else
      redirect_to :back, notice: 'Something was wrong'
    end
  end

  def mark_as_unavailable
    if params[:time].present?
      @saved = params[:time].each do |time|
        @booking = Booking.new(pro: current_user, start_at: booking_start_at(time))
        authorize @booking
        @booking.save
      end
      if no_errors?
        redirect_to bookings_url(date: params[:date]), notice: 'slots were marked as unavailable'
      else
        redirect_to :back, notice: @booking.errors.full_messages.join(', ')
      end
    else
      redirect_to :back, notice: 'Choose time slots'
    end
  end

  def destroy
    @booking = Booking.find(params[:id])
    authorize @booking
    @booking.destroy
    redirect_to bookings_path(date: params[:date]), notice: 'slot is now available'
  end

  private

  def no_errors?
    @saved && @booking.errors.full_messages.empty?
  end

  def set_date
    @date = params[:date] ? Date.parse(params[:date]) : Time.zone.now.to_date
  end

  def booking_start_at(time)
    @datetime = DateTime.parse(params[:date]) + (time.to_i * 30).minutes
  end

  def set_treatment
    @treatment ||= Treatment.find(params[:treat])
  end
end
