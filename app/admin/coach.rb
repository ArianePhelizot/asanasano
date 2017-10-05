# frozen_string_literal: true

ActiveAdmin.register Coach do

  permit_params :description, :experience, :params_set_id, languages: [], sports: []

  index do
    column :user_id, sortable: :user_id do |coach|
      coach
    end
    column :coach_id, sortable: :coach_id do |coach|
      coach.id
    end
    column :description
    column :experience
    column :languages
    column :sports do
    raw coach.sports
  end
    column :params_set
    actions
  end

end

