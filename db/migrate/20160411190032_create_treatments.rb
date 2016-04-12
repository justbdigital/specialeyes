class CreateTreatments < ActiveRecord::Migration
  def change
    create_table :treatments do |t|
      t.string  :title
      t.string  :kind
      t.text :description

      t.timestamps null: false
    end
  end
end
