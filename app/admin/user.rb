# frozen_string_literal: true

ActiveAdmin.register User do
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #


  #Je n'arrive pas à updater les champs d'un user  cause de l'acceptance des terms
  #je n'arrive pas à dire / imposer que dans les permit_params => agreed_to_terms: true
  #ni à overider l'udate d'active admin => à acun moment je n'arrive à rentrer dans mon binding.pry
# Test this...but doesn't work http://time.to.pullthepl.ug/blog/2012/5/18/bending-activeadmin-to-my-will-with-a-customized-update-action/
  # def update
  #   binding.pry
  #   # This sets the attr_accessor you want later
  #   params[:user].merge!({ :agreed_to_terms => true })
  #   # This is taken from the active_admin code
  #   super
  # end


  menu label: "Users"
  permit_params :email, :first_name, :last_name, :coach_id , :phone_number, :admin, :user_terms_acceptance

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
    column :user_terms_acceptance
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
