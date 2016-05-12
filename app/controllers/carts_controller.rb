class CartsController < ApplicationController
  def show
    cart_ids = $redis.smembers current_user.cart
    @cart_bookings = Booking.find(cart_ids)
    @cart_total = @cart_bookings.sum(&:sum)

    total_minus_balance = @cart_total - current_user.balance.amount
    @subtotal = total_minus_balance > 0 ? total_minus_balance.to_i : 0
  end
end
