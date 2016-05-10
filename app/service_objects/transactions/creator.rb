module Transactions
  class Creator
    def initialize(params, current_user)
      @payment_method = params[:payment_method_nonce]
      @first_name = params[:first_name]
      @last_name = params[:last_name]
      @phone = params[:phone]
      @gift = params[:gift] unless params[:gift].blank?
      @current_user = current_user
    end

    def call
      ActiveRecord::Base.transaction do
        braintree_transaction

        if @result.success? && @gift
          create_gift
          user_update
        elsif @result.success?
          empty_cart
          user_update
        else
          gon.client_token = generate_client_token
        end
        @result
      end
    end

    private

    def braintree_transaction
      sum = @gift || (cart_total * 1.26707).round(2) # need to change braintree default currency to pound

      if !@current_user.has_payment_info?
        @result = Braintree::Transaction.sale(
          amount: sum,
          payment_method_nonce: @payment_method,
          customer: {
            first_name: @first_name,
            last_name: @last_name,
            email: @current_user.email,
            phone: @phone
          },
          options: {
            store_in_vault: true
          })
      else
        @result = Braintree::Transaction.sale(
          amount: sum,
          payment_method_nonce: @payment_method)
      end
    end

    def create_gift
      voucher = Voucher.new(creator: @current_user, amount: @gift, paid: true)
      voucher.save
    end

    def empty_cart
      Booking.where(id: cart_ids).update_all(paid: true, confirmed: true)
      $redis.del @current_user.cart
    end

    def user_update
      @current_user.update(braintree_customer_id: @result.transaction.customer_details.id) unless @current_user.has_payment_info?
    end

    def cart_ids
      $redis.smembers @current_user.cart
    end

    def cart_total
      Booking.find(cart_ids).sum(&:sum)
    end

    def generate_client_token
      if @current_user.has_payment_info?
        Braintree::ClientToken.generate(customer_id: @current_user.braintree_customer_id)
      else
        Braintree::ClientToken.generate
      end
    end
  end
end