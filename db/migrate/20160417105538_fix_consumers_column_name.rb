class FixConsumersColumnName < ActiveRecord::Migration
  def change
    rename_column :consumers, :sex, :female
  end
end
