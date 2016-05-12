class CreateVouchers < ActiveRecord::Migration
  def change
    create_table :vouchers do |t|
      t.references :creator, polymorphic: true
      t.integer :owner_id
      t.string :code
      t.boolean :paid, default: false
      t.boolean :used, default: false
      t.decimal :amount, precision: 16, scale: 2
      t.datetime :valid_till

      t.timestamps null: false
    end
  end
end
