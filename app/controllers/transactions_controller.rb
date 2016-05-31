class TransactionsController < ApplicationController
  before_action :authenticate_user!, only: [:index]
  before_action :check_cart!, only: [:new]

  def index
    @bookings = Booking.where(consumer: current_user, confirmed: true).order(:paid)
  end

  def new
    allowance = Bookings::CheckAllowance.new(params)
    redirect_to :back, notice: allowance.notice and return unless allowance.call

    set_gift_info if buying_gift?
    update_total if paying_with_gift?
    gon.client_token = generate_client_token
    @cart_total = @gift || cart_total
  end

  def create
    base = Transactions::Creator.new(params, current_user)
    transaction = base.call
    notice = base.notice

    if transaction.success? && !params[:balance_payment].blank?
      redirect_to root_url, notice: "Your transaction has been successful! New balance £ #{current_user.balance.amount.to_i}. #{notice}"
    elsif transaction.success? && !params[:gift].blank?
      redirect_to gifts_balance_url, notice: 'You bought a gift!'
    elsif transaction.success?
      redirect_to root_url, notice: "Congratulations! Your transaction has been successfully processed! #{notice}"
    else
      flash[:alert] = 'Something went wrong while processing your transaction. Please try again!'
      render :new
    end
  end

  private

  def buying_gift?
    params[:gift] && params[:gift][:amount]
  end

  def paying_with_gift?
    params[:gifts_amount] && params[:total]
  end

  def set_gift_info
    quantity = params[:gift][:quantity].to_i
    amount = params[:gift][:amount].to_i
    @gift = quantity ? amount * quantity : amount
  end

  def update_total
    @gift = params[:total].to_i - params[:gifts_amount].to_i
  end

  def cart_ids
    ShoppingCart.new(current_user).cart_ids
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
