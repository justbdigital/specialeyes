class CreateDailySchedules < ActiveRecord::Migration
  def change
    create_table :daily_schedules do |t|
      t.integer :day
      t.integer :open_at_slot
      t.integer :close_at_slot
      t.references :pro, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
