class AddMemberOfIdToPros < ActiveRecord::Migration
  def change
    add_column :pros, :member_of_id, :integer
  end
end
