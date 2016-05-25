class AddPostcodeToVenue < ActiveRecord::Migration
  def change
    add_column :venues, :postcode, :string
  end
end
