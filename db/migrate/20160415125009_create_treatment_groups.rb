class CreateTreatmentGroups < ActiveRecord::Migration
  def change
    create_table :treatment_groups do |t|
      t.references :pro
      t.string :name

      t.timestamps null: false
    end
  end
end
