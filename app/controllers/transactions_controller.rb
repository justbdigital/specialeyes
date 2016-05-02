class TransactionsController < ApplicationController
  before_action :authenticate_user!, only: [:index]
  before_action :check_cart!, only: [:new, :create]

  def index
    @bookings = Booking.where(consumer: current_user, confirmed: true).order(:paid)
  end

  def new
    gon.client_token = generate_client_token
    @cart_total = cart_total
  end

  def create
    sum = (cart_total * 1.26707).round(2) # need to change braintree default currency to pound

    unless current_user.has_payment_info?
      @result = Braintree::Transaction.sale(
                  amount: sum,
                  payment_method_nonce: params[:payment_method_nonce],
                  customer: {
                    first_name: params[:first_name],
                    last_name: params[:last_name],
                    email: current_user.email,
                    phone: params[:phone]
                  },
                  options: {
                    store_in_vault: true
                  })
    else
      @result = Braintree::Transaction.sale(
                  amount: sum,
                  payment_method_nonce: params[:payment_method_nonce])
    end

    if @result.success?
      current_user.update(braintree_customer_id: @result.transaction.customer_details.id) unless current_user.has_payment_info?
      Booking.where(id: cart_ids).update_all(paid: true, confirmed: true)
      $redis.del current_user.cart
      redirect_to root_url, notice: 'Congraulations! Your transaction has been successfully!'
    else
      flash[:alert] = 'Something went wrong while processing your transaction. Please try again!'
      gon.client_token = generate_client_token
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
    if Booking.find(cart_ids).blank?
      redirect_to root_url, alert: "Please add some items to your cart before processing your transaction!"
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
