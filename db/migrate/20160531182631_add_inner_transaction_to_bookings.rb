class AddInnerTransactionToBookings < ActiveRecord::Migration
  def change
    add_reference :bookings, :inner_transaction, index: true, foreign_key: true
  end
end
