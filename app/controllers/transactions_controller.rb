class TransactionsController < ApplicationController
  before_action :authenticate_user!, only: [:index]
  before_action :check_cart!, only: [:new]

  def index
    @bookings = Booking.where(consumer: current_user, confirmed: true).order(:paid)
  end

  def new
    gon.client_token = generate_client_token
    @gift = params[:gift][:amount].to_i if params[:gift] && params[:gift][:amount]
    @cart_total = @gift || cart_total
  end

  def create
    transaction = Transactions::Creator.new(params, current_user).call

    if transaction.success? && !params[:gift].blank?
      redirect_to gifts_balance_url, notice: 'You bought a gift!'
    elsif transaction.success?
      redirect_to root_url, notice: 'Congraulations! Your transaction has been successfully!'
    else
      flash[:alert] = 'Something went wrong while processing your transaction. Please try again!'
      render :new
    end
  end

  private

  def cart_ids
    $redis.smembers current_user.cart
  end

  def cart_total
    Booking.find(cart_ids).sum(&:sum)
  end

  def check_cart!
    if Booking.find(cart_ids).blank? && !params[:gift][:amount]
      redirect_to root_url, alert: 'Please add some items to your cart before processing your transaction!'
    end
  end

  def generate_client_token
    if current_user.has_payment_info?
      Braintree::ClientToken.generate(customer_id: current_user.braintree_customer_id)
    else
      Braintree::ClientToken.generate
    end
  end
end
