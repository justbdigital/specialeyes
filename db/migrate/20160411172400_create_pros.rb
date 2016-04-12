class CreatePros < ActiveRecord::Migration
  def change
    create_table :pros do |t|
      t.string  :username
      t.string  :business_name

      t.timestamps null: false
    end
  end
end
