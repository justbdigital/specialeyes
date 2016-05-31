class CreateInnerTransactions < ActiveRecord::Migration
  def change
    create_table :inner_transactions do |t|
      t.decimal :amount, precision: 16, scale: 2
      t.references :creator, polymorphic: true, index: true

      t.timestamps null: false
    end
  end
end
