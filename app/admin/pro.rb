ActiveAdmin.register Pro do

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
    column :username
    column :business_name
    column :email
    column :suspended
    actions
  end

  filter :username
  filter :business_name
  filter :email
  filter :suspended

  form do |f|
    f.inputs "#{resource.username} details" do
      f.input :suspended
    end
    f.actions
  end

end
