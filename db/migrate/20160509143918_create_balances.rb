class CreateBalances < ActiveRecord::Migration
  def change
    create_table :balances do |t|
      t.references :consumer, index: true, foreign_key: true
      t.boolean :active, default: true
      t.decimal :amount, precision: 16, scale: 2, default: 0.0

      t.timestamps null: false
    end
  end
end
