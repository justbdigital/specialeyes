class AddFeaturedToTreatments < ActiveRecord::Migration
  def change
    add_column :treatments, :featured, :boolean, default: false
  end
end
