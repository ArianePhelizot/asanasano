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
  has_many :card_registrations
  has_one :iban, dependent: :nullify
  after_initialize :default_values

  validates :user_id, :person_type, presence: true
  validates :person_type, inclusion: { in: %w(NATURAL LEGAL) }
  validates :first_name, :last_name, :birthday, :country_of_residence,
            :nationality, presence: true, if: :natural?
  validates :legal_person_type, :legal_name,
            :legal_representative_first_name, :legal_representative_last_name,
            :legal_representative_birthday, :legal_representative_country_of_residence,
            :legal_representative_nationality,
            presence: true, if: :legal?
  validates :legal_person_type, inclusion: { in: %w(BUSINESS ORGANIZATION SOLETRADER) }, if: :legal?

  def natural?
    person_type == "NATURAL"
  end

  def legal?
    person_type == "LEGAL"
  end

  def default_values
    self.first_name ||= User.find(user_id).first_name
    self.last_name ||= User.find(user_id).last_name
    self.person_type ||= "NATURAL"
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
end
