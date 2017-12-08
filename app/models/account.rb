# == Schema Information
#
# Table name: accounts
#
#  id                                        :integer          not null, primary key
#  user_id                                   :integer
#  person_type                               :string
#  tag                                       :string
#  first_name                                :string
#  last_name                                 :string
#  birthday                                  :datetime
#  country_of_residence                      :string
#  nationality                               :string
#  legal_person_type                         :string
#  legal_name                                :string
#  legal_representative_first_name           :string
#  legal_representative_last_name            :string
#  legal_representative_birthday             :datetime
#  headquarters_address                      :string
#  legal_representative_country_of_residence :string
#  legal_representative_nationality          :string
#  created_at                                :datetime         not null
#  updated_at                                :datetime         not null
#  mangopay_id                               :integer
#  address_line1                             :string
#  address_line2                             :string
#  city                                      :string
#  region                                    :string
#  postal_code                               :string
#
# Indexes
#
#  index_accounts_on_user_id  (user_id)
#

class Account < ApplicationRecord
  belongs_to :user, optional: true
  has_one :wallet, dependent: :nullify
  has_one :iban, dependent: :nullify
  after_initialize :default_values

  validates :user_id, :person_type, presence: true
  validates :person_type, inclusion: ["PERSONNE PHYSIQUE", "PERSONNE MORALE"]
  validates :first_name, :last_name, :birthday, :country_of_residence,
            :nationality, presence: true, if: :natural?
  validates :legal_person_type, :legal_name,
            :legal_representative_first_name, :legal_representative_last_name,
            :legal_representative_birthday, :legal_representative_country_of_residence,
            :legal_representative_nationality,
            presence: true, if: :legal?
  validates :legal_person_type, inclusion: ["business", "organization", "soletrader"],
                                if: :legal?

  def natural?
    person_type == "PERSONNE PHYSIQUE"
  end

  def legal?
    person_type == "PERSONNE MORALE"
  end

  def default_values
    self.first_name ||= User.find(user_id).first_name
    self.last_name ||= User.find(user_id).last_name
    self.person_type ||= "PERSONNE PHYSIQUE"
    self.country_of_residence ||= "FR"
    self.nationality ||= "FR"
    self.legal_representative_country_of_residence ||= "FR"
    self.legal_representative_nationality ||= "FR"
  end

  def country_name_of_residence
    country = ISO3166::Country[country_of_residence]
    country.translations[I18n.locale.to_s] || country.name
  end

  def country_name_of_nationality
    country = ISO3166::Country[nationality]
    country.translations[I18n.locale.to_s] || country.name
  end

  def country_name_of_legal_representative_residence
    country = ISO3166::Country[legal_representative_country_of_residence]
    country.translations[I18n.locale.to_s] || country.name
  end

  def country_name_of_legal_representative_nationality
    country = ISO3166::Country[legal_representative_nationality]
    country.translations[I18n.locale.to_s] || country.name
  end

  # rubocop:disable Metrics/MethodLength
  def address
    if self.person_type == "PERSONNE PHYSIQUE"
      { "AddressLine1": address_line1,
        "AddressLine2": address_line2,
        "City": city,
        "Region": region,
        "PostalCode": postal_code,
        "Country": self.country_of_residence }
    else
      [headquarters_address,
       country_name_of_legal_representative_residence].join(" ")
    end
  end
  # rubocop:enable Metrics/MethodLength
end
