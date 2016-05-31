class CartsController < ApplicationController
  def show
    cart_ids = ShoppingCart.new(current_user).cart_ids
    @cart_bookings = Booking.find(cart_ids)
    @cart_total = @cart_bookings.sum(&:sum)

    @subtotal = diff > 0 ? diff.to_i : 0
  end

  private

  def diff
    @gift_balance ||= current_user.balance&.amount ? current_user.balance.amount : 0
    @total_minus_balance ||= @cart_total - @gift_balance
  end
end
