class AddColumnToBooking < ActiveRecord::Migration
  def change
    add_column :bookings, :confirmed, :boolean, default: false
  end
end
