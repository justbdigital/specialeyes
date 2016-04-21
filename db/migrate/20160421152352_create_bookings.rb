class CreateBookings < ActiveRecord::Migration
  def change
    create_table :bookings do |t|
      t.datetime :start_at
      t.integer :sum
      t.references :pro, index: true, foreign_key: true
      t.references :consumer, index: true, foreign_key: true
      t.references :treatment, index: true, foreign_key: true
      t.boolean :paid

      t.timestamps null: false
    end
  end
end
