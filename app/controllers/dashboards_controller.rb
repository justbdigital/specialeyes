class DashboardsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_pending_bookings
  before_action :set_venue

  def show
    @impressionist_count = @venue&.impressionist_count(start_date: Time.now.beginning_of_month) || 0
  end

  private

  def set_venue
    @venue = current_user.venue
  end

  def set_pending_bookings
    arel = Booking.arel_table

    @bookings ||= current_user
                  .bookings
                  .order(:start_at)
                  .where(arel[:start_at]
                  .gteq(Time.zone.now))
  end
end
