class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.integer  :owner_id

      t.timestamps null: false
    end
  end
end
