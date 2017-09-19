# frozen_string_literal: true

ActiveAdmin.register Course do
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  permit_params :name, :content, :address, :lat, :lng, :meeting_point,
                :capacity_max, :details, :group_id, :coach_id, :sport_id, :status
  #
  # or
  #
  # permit_params do
  #   permitted = [:permitted, :attributes]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
end

