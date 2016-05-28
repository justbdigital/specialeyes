module Bookings
  class CheckAllowance
    def initialize(params, current_user = nil)
      @params = params
      @current_user = current_user
    end

    def call
      @current_user ? check : check_for_gift
    end

    def notice
      @notice
    end

    private

    def check
      return true unless @params[:payment] == 'half'
      @notice = 'Please choose payment method' and return false if @params[:payment].blank?
      @notice = 'Amount should be a positive number' and return false if !amount_is_positive_integer?
      @notice = "Please enter amount less or equal than balance (£ #{@current_user.balance.amount.to_i})" and return false if gifts_not_enough?
      @notice = "Please enter amount less or equal than order total (£ #{@params[:total].to_i})" and return false if gift_more_than_total?

      true
    end

    def check_for_gift
      return true unless @params[:gift]
      @notice = 'choose gift amount' and return false if !@params[:gift][:amount]
      @notice = 'choose gift quantity' and return false if !@params[:gift][:quantity]
      @notice = 'quantity should be a positive number' and return false if !quantity_is_positive_integer?
      @notice = 'enter email to send a gift' and return false if !@params[:gift][:email]
      @notice = 'no consumer with such email' and return false if !consumer

      true
    end

    def gifts_not_enough?
      @params[:gifts_amount].to_i > @current_user.balance.amount
    end

    def gift_more_than_total?
      @params[:gifts_amount].to_i > @params[:total].to_i
    end

    def amount_is_positive_integer?
      amount = Integer(@params[:gifts_amount]) rescue nil
      amount.to_i > 0
    end

    def consumer
      Consumer.find_by(email: @params[:gift][:email])
    end

    def quantity_is_positive_integer?
      quantity = Integer(@params[:gift][:quantity]) rescue nil
      quantity.to_i > 0
    end
  end
end
