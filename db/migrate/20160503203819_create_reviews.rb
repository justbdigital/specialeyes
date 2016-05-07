class CreateReviews < ActiveRecord::Migration
  def change
    create_table :reviews do |t|
      t.references :booking, index: true, foreign_key: true
      t.references :consumer, index: true, foreign_key: true
      t.references :venue, index: true, foreign_key: true
      t.integer :ambiance
      t.integer :cleanliness
      t.integer :staff
      t.integer :value
      t.text :comment

      t.timestamps null: false
    end
  end
end
