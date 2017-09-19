ActiveAdmin.register Account do
# See permitted parameters documentation:
# https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
#
permit_params :user_id, :person_type, :tag,
              :first_name, :last_name, :birthday, :country_of_residence,
              :nationality,
              :legal_person_type, :legal_name, :legal_representative_first_name,
              :legal_representative_last_name, :legal_representative_birthday,
              :headquarters_address, :legal_representative_country_of_residence,
              :legal_representative_nationality, :created_at, :updated_at,
              :mangopay_id, :address_line1, :address_line2, :city, :region,
              :postal_code
#
# or
#
# permit_params do
#   permitted = [:permitted, :attributes]
#   permitted << :other if params[:action] == 'create' && current_user.admin?
#   permitted
# end

end
