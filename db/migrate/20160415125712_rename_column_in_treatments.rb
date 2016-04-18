class RenameColumnInTreatments < ActiveRecord::Migration
  def change
    rename_column :treatments, :treatment_grout_id, :treatment_group_id
  end
end
