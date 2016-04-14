class CreateVenues < ActiveRecord::Migration
  def change
    create_table :venues do |t|
      t.references :pro
      t.string :image
      t.string :name
      t.string :address
      t.string :phone
      t.string :email
      t.string :website
      t.string :primary_type
      t.text :description
      t.float :latitude
      t.float :longitude

      t.timestamps null: false
    end
  end
end
