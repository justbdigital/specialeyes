ActiveAdmin.register Consumer do

# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
permit_params :suspended
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end

  index do
    column :first_name
    column :last_name
    column :profile_name
    column :phone
    column :female
    column :postcode
    column :email
    column :suspended
    actions
  end

  filter :first_name
  filter :last_name
  filter :profile_name
  filter :phone
  filter :female
  filter :postcode
  filter :email
  filter :suspended

  form do |f|
    f.inputs "#{resource.first_name} #{resource.last_name} details" do
      f.input :suspended
    end
    f.actions
  end

end
