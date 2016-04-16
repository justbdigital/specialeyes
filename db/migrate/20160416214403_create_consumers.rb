class CreateConsumers < ActiveRecord::Migration
  def change
    create_table :consumers do |t|
      t.string :first_name
      t.string :last_name
      t.string :phone
      t.string :profile_name
      t.string :postcode
      t.boolean :sex

      t.timestamps null: false
    end
  end
end
