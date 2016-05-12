class BookingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_treatment, only: [:create]
  before_action :set_date, only: [:calendar, :new]
  before_action :set_booking, only: [:destroy, :complete]

  def index
    authorize Booking
    @bookings = current_user
                .bookings
                .order(created_at: :desc)
                .where(confirmed: true)
                .paginate(page: params[:page], per_page: 30)
  end

  def calendar
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
        $redis.sadd current_user.cart, @booking.id
        redirect_to cart_path, notice: 'booking created and treatment added to your cart'
      else
        redirect_to :back, notice: @booking.errors.full_messages.join(', ')
      end
    else
      redirect_to :back, notice: 'Something was wrong'
    end
  end

  def complete
    authorize @booking
    if @booking.update(completed: true)
      redirect_to :back, notice: 'Booking has been completed'
    else
      redirect_to :back, notice: @booking.errors.full_messages.join(', ')
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
        redirect_to calendar_bookings_url(date: params[:date]), notice: 'slots were marked as unavailable'
      else
        redirect_to :back, notice: @booking.errors.full_messages.join(', ')
      end
    else
      redirect_to :back, notice: 'Choose time slots'
    end
  end

  def confirm
    if params[:payment] == 'yes'
      redirect_to new_transaction_path
    else
      cart_ids = $redis.smembers current_user.cart
      Booking.where(id: cart_ids).update_all(confirmed: true)
      $redis.del current_user.cart
      redirect_to :root, notice: 'Your order now confirmed. Payment will be needed at venue'
    end
  end

  def destroy
    authorize @booking
    id = @booking.id
    @booking.destroy

    if current_user.is_a? Consumer
      $redis.srem current_user.cart, id
      redirect_to cart_path, notice: 'treatment was deleted from your shopping cart'
    else
      redirect_to calendar_bookings_path(date: params[:date]), notice: 'slot is now available'
    end
  end

  private

  def set_booking
    @booking = Booking.find(params[:id])
  end

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
