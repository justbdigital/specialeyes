class ChangeDefaultInBookings < ActiveRecord::Migration
  def change
    change_column :bookings, :paid, :boolean, default: false
  end
end
