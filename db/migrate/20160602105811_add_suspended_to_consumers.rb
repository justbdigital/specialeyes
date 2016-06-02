class AddSuspendedToConsumers < ActiveRecord::Migration
  def change
    add_column :consumers, :suspended, :boolean, default: false
  end
end
