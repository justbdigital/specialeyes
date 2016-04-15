class AddDurationToTreatments < ActiveRecord::Migration
  def change
    add_column :treatments, :pro_id, :integer
    add_column :treatments, :sale_price, :integer
    add_column :treatments, :price, :integer
    add_column :treatments, :duration, :string
    add_column :treatments, :treatment_type, :string
  end
end
