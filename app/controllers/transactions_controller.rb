class TransactionsController < ApplicationController
  before_action :check_cart!

  def new
    gon.client_token = generate_client_token
    @cart_total = cart_total
  end

  def create
    sum = (cart_total * 1.26707).round(2) # need to change braintree default currency to pound

    @result = Braintree::Transaction.sale(
      amount: sum,
      payment_method_nonce: params[:payment_method_nonce])
    if @result.success?
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
    Braintree::ClientToken.generate
  end
end
