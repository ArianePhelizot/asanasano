# frozen_string_literal: true

ActiveAdmin.register User do
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  permit_params :email, :first_name, :last_name, :coach_id , :phone_number, :admin
  #
  # or
  #
  # permit_params do
  #   permitted = [:permitted, :attributes]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end


  index do
    selectable_column
    column :id
    column :coach_id
    column :email
    column :last_name
    column :first_name
    column :admin
    column :phone_number
    column :created_at
    actions
    column :sign_in_count
    column :current_sign_in_at
    column :last_sign_in_at
    column :invited_by_id
    column :invitations_count
    column :facebook_picture_url
  end


  # show do
  #   panel 'Groups' do
  #     table_for user.groups do
  #       column 'name', &:name
  #       column 'owner', &:owner
  #     end
  #   end
  # end
end
