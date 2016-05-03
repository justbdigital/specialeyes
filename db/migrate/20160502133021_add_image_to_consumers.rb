class AddImageToConsumers < ActiveRecord::Migration
  def change
    add_column :consumers, :image, :string
  end
end
