class ShoppingCart
  def initialize(user, booking_id = nil)
    @user = user
    @booking_id = booking_id
  end

  def add
    redis_db.sadd cart, @booking_id
  end

  def remove
    redis_db.srem cart, @booking_id
  end

  def clean!
    redis_db.del cart
  end

  def cart_count
    redis_db.scard cart
  end

  def cart_ids
    redis_db.smembers cart
  end

  private

  def cart
    "cart#{@user.id}"
  end

  def redis_db
    @_redis_connection ||= Redis.new(driver: :hiredis)
  end
end
