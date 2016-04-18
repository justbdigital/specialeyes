class ChangeKindToMenuGroupIdInTreatments < ActiveRecord::Migration
  def change
    remove_column :treatments, :kind
    add_column :treatments, :treatment_grout_id, :integer
  end
end
