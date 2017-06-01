ActiveAdmin.register User do
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
# permit_params :list, :of, :attributes, :on, :model
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end

  show do
    panel 'Groups' do
      table_for user.groups do
        column 'name' do |group|
          group.name
        end
        column 'owner' do |group|
          group.owner
        end
      end
    end
  end


end
