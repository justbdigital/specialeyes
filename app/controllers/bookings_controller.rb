class BookingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_treatment, only: [:create]
  before_action :set_date, only: [:calendar, :new]
  before_action :set_booking, only: [:destroy, :complete]
  before_action :check_allowance!, only: [:confirm]

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
    redirect_to :back, notice: 'You should be signed in as consumer' and return if current_user.is_a? Pro
    redirect_to :back, notice: 'Something was wrong' and return unless current_user.is_a? Consumer

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
    redirect_to :back, notice: 'Choose time slots' and return unless params[:time].present?

    @saved = params[:time].each do |time|
      @booking = Booking.new(pro: current_user, start_at: booking_start_at(time))
      authorize @booking
      @booking.save
    end
    if @saved && @booking.errors.full_messages.empty?
      redirect_to calendar_bookings_url(date: params[:date]), notice: 'slots were marked as unavailable'
    else
      redirect_to :back, notice: @booking.errors.full_messages.join(', ')
    end
  end

  def confirm
    redirect_to :back, notice: 'Nothing in the cart' and return if cart_ids.blank?

    case params[:payment]
    when 'yes'
      redirect_to new_transaction_path
    when 'half'
      if transaction_needed?
        redirect_to new_transaction_path(total: params[:total], gifts_amount: params[:gifts_amount])
      else
        use_gift_balance
        redirect_to :root, notice: "Your order now paid. New balance £ #{current_user.balance.amount.to_i}"
      end
    when 'no'
      update_bookings_and_empty_cart
      redirect_to :root, notice: 'Your order now confirmed. Payment will be needed at venue'
    else
      redirect_to :back, notice: 'Choose payment method'
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

  def set_date
    @date = params[:date] ? Date.parse(params[:date]) : Time.zone.now.to_date
  end

  def booking_start_at(time)
    @datetime = DateTime.parse(params[:date]) + (time.to_i * 30).minutes
  end

  def set_treatment
    @treatment ||= Treatment.find(params[:treat])
  end

  def check_allowance!
    return true unless params[:payment] == 'half'
    if params[:payment].blank?
      redirect_to :back, notice: 'Please choose payment method'
    elsif !amount_is_positive_integer?
      redirect_to :back, alert: 'Amount should be a positive number'
    elsif params[:gifts_amount].to_i > current_user.balance.amount
      redirect_to :back, alert: "Please enter amount less or equal than balance (£ #{current_user.balance.amount.to_i})"
    elsif params[:gifts_amount].to_i > params[:total].to_i
      redirect_to :back, alert: "Please enter amount less or equal than order total (£ #{params[:total].to_i})"
    else
      true
    end
  end

  def amount_is_positive_integer?
    amount = Integer(params[:gifts_amount]) rescue nil
    amount.to_i > 0
  end

  def use_gift_balance
    Balance.transaction do
      balance = current_user.balance
      balance.amount -= params[:total].to_i
      balance.save
      update_bookings_and_empty_cart(true)
    end
  end

  def transaction_needed?
    (params[:total].to_i - params[:gifts_amount].to_i) > 0
  end

  def update_bookings_and_empty_cart(paid = false)
    Booking.where(id: cart_ids).update_all(confirmed: true, paid: paid)
    $redis.del current_user.cart
  end

  def cart_ids
    @cart_ids = $redis.smembers current_user.cart
  end
end
