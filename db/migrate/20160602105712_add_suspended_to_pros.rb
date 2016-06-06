class AddSuspendedToPros < ActiveRecord::Migration
  def change
    add_column :pros, :suspended, :boolean, default: false
  end
end
