class TransactionsController < ApplicationController

  def new
    $total_priceeee = (params[:total].to_i * 1.26707).round(2)
    gon.client_token = generate_client_token
  end

  def create
    @result = Braintree::Transaction.sale(
      amount: $total_priceeee,
      payment_method_nonce: params[:payment_method_nonce])
    if @result.success?
      redirect_to root_url, notice: 'Congraulations! Your transaction has been successfully!'
    else
      flash[:alert] = 'Something went wrong while processing your transaction. Please try again!'
      gon.client_token = generate_client_token
      render :new
    end
  end

  private

  def generate_client_token
    Braintree::ClientToken.generate
  end
end
