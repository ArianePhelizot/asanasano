# == Schema Information
#
# Table name: card_registrations
#
#  id                    :integer          not null, primary key
#  account_id            :integer
#  mangopay_id           :integer
#  tag                   :string
#  access_key            :string
#  preregistration_data  :string
#  card_registration_url :string
#  registration_data     :string
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#
# Indexes
#
#  index_card_registrations_on_account_id  (account_id)
#

class CardRegistration < ApplicationRecord
  belongs_to :account
end
