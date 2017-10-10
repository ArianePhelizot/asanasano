# frozen_string_literal: true

ActiveAdmin.register Slot do
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters

  permit_params :participants_min, :date, :start_at, :end_at, :price_cents, :specificities, :status, :course_id


index do
    column :id
    column :date
    column :participants_min
    column :price_cents
    column :currency
    column :specificities
    column :status
    column :course
    column :coach_id, sortable: :slot do |slot|
      slot.course.coach.first_name
    end
    column :participants, :slot do |slot|
      slot.users.count
    end
    column :start_at
    column :end_at
    column :payout_mangopay_id
    column :created_at
    column :updated_at
    actions
  end


show do

  participants_list = []

  attributes_table do
    row :id
    row :date
    row :participants_min
    row :price_cents
    row :currency
    row :specificities
    row :status
    row :course
    row :coach_id, sortable: :slot do |slot|
      slot.course.coach.first_name
    end
    row :participants, :slot do |slot|
      slot.users.count
    end
    row :participants_list, :slot do |slot|
      slot.users.each do |user|
        participants_list << user
      end
    end
    row :start_at
    row :end_at
    row :payout_mangopay_id
    row :created_at
    row :updated_at
    active_admin_comments
  end
end


# Détails de Slot
# DATE  mercredi 11 octobre 2017
# PARTICIPANTS MIN  6
# PRICE CENTS 1500
# PRICE CURRENCY  EUR
# SPECIFICITIES Merci de venir 5 minutes avant le début de la séance pour que nous puissions commencer à l'heure
# STATUS  created
# COURSE  Tai Chi Chuan
# CREATED AT  jeudi 28 septembre 2017 15h35
# UPDATED AT  jeudi 28 septembre 2017 15h35
# START AT  mercredi 11 octobre 2017 13h00
# END AT  mercredi 11 octobre 2017 13h45
# PAYOUT MANGOPAY
end



