class AddCompletedToBookings < ActiveRecord::Migration
  def change
    add_column :bookings, :completed, :boolean, default: false
  end
end
