module Transactions
  class Creator
    def initialize(params, current_user)
      @payment_method = params[:payment_method_nonce]
      @first_name = params[:first_name]
      @last_name = params[:last_name]
      @phone = params[:phone]
      @gift = params[:gift] unless params[:gift].blank?
      @email = params[:email]
      @message = params[:message]
      @current_user = current_user
      @balance_payment = params[:balance_payment]
      @quantity = params[:quantity]
    end

    def call
      ActiveRecord::Base.transaction do
        braintree_transaction
        gon.client_token = generate_client_token and return unless @result.success?

        user_update
        create_inner_transaction

        unless @email.blank?
          create_gifts
        else
          empty_cart
          send_sms
          update_balance unless @balance_payment.blank?
        end
        @result
      end
    end

    def notice
      @notice
    end

    private

    def braintree_transaction
      @sum = @gift || cart_total.round(2) # need to change braintree default currency to pound

      if !@current_user.has_payment_info?
        @result = Braintree::Transaction.sale(
          amount: @sum,
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
          amount: @sum,
          payment_method_nonce: @payment_method)
      end
    end

    def create_gifts
      quantity = @quantity.to_i
      return false unless quantity > 0

      @vouchers = []
      amount = @gift.to_i / quantity
      quantity.times { @vouchers << Voucher.create(creator: @current_user, amount: amount, paid: true, inner_transaction_id: @transaction.id) }
      ConsumerMailer.gift_card_email(consumer, @vouchers).deliver if consumer
    end

    def update_balance
      balance = @current_user.balance
      balance.amount -= @balance_payment.to_i
      balance.save
    end

    def consumer
      @consumer ||= Consumer.find_by(email: @email)
    end

    def empty_cart
      @bookings = Booking.where(id: cart_ids)
      @bookings.update_all(paid: true, confirmed: true, inner_transaction_id: @transaction.id)
      ShoppingCart.new(@current_user).clean!
    end

    def create_inner_transaction
      @transaction ||= InnerTransaction.create(creator: @current_user, amount: @sum)
    end

    def send_sms
      client = Textmagic::REST::Client.new(ENV['TEXTMAGIC_USERNAME'], ENV['TEXTMAGIC_APIV2_KEY'])
      @message = []
      @bookings.each do |b|
        text = "Your #{b.treatment.title} treatment in #{b.pro.venue.name} venue starts on #{b.start_at.strftime("%B %d at %H:%M")}"
        time = b.start_at - 1.days
        client.messages.create(phones: @current_user.phone, text: text, sendingTime: time.to_i)
        @message << text
      end
      client.messages.create(phones: @current_user.phone, text: @message.join(', '))
    rescue Textmagic::REST::RequestError => e
      @notice = 'To receive confirmation sms please check your phone number in account details' if e
    end

    def user_update
      @current_user.update(braintree_customer_id: @result.transaction.customer_details.id) unless @current_user.has_payment_info?
    end

    def cart_ids
      ShoppingCart.new(@current_user).cart_ids
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
