class CartsController < ApplicationController
  def show
    cart_ids = $redis.smembers current_user.cart
    @cart_bookings = Booking.find(cart_ids)
    @cart_total = @cart_bookings.sum(&:sum)
  end
end
