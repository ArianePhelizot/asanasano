# frozen_string_literal: true

ActiveAdmin.register Group do
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  permit_params :name, :owner_id, users: [], coaches: []
  #
  # or
  #
  # permit_params do
  #   permitted = [:permitted, :attributes]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  # index do
  #   selectable_column
  #   column :name
  #   column :owner_id
  #   column :users, :group do |group|
  #     group.users
  #     end
  #   column :coaches, :group do |group|
  #     group.coaches
  #     end
  # end

#   show do
#   panel "Patients" do
#     table_for physician.appointments do
#       column "name" do |appointment|
#         appointment.patient.name
#       end
#       column :appointment_date
#     end
#   end
# end


#   show do
#   panel "Users" do
#     table_for group.users do
#       column "users" do |user|
#         group.user
#       end
#       column :users
#     end
#   end
# end

end
