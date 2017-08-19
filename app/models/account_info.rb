# == Schema Information
#
# Table name: account_infos
#
#  id                                        :integer          not null, primary key
#  user_id                                   :integer
#  person_type                               :string
#  tag                                       :string
#  first_name                                :string
#  last_name                                 :string
#  birthday                                  :datetime
#  address                                   :string
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
#
# Indexes
#
#  index_account_infos_on_user_id  (user_id)
#

class AccountInfo < ApplicationRecord
  COUNTRY_LIST = %w(AD AE AF AG AI AL AM AO AQ AR AS AT AU AW AX AZ BA
                    BB BD BE BF BG BH BI BJ BL BM BN BO BQ BR BS BT BV
                    BW BY BZ CA CC CD CF CG CH CI CK CL CM CN CO CR CU
                    CV CW CX CY CZ DE DJ DK DM DO DZ EC EE EG EH ER ES
                    ET FI FJ FK FM FO FR GA GB GD GE GF GG GH GI GL GM
                    GN GP GQ GR GS GT GU GW GY HK HM HN HR HT HU ID IE
                    IL IM IN IO IQ IR IS IT JE JM JO JP KE KG KH KI KM
                    KN KP KR KW KY KZ LA LB LC LI LK LR LS LT LU LV LY
                    MA MC MD ME MF MG MH MK ML MM MN MO MP MQ MR MS MT
                    MU MV MW MX MY MZ NA NC NE NF NG NI NL NO NP NR NU
                    NZ OM PA PE PF PG PH PK PL PM PN PR PS PT PW PY QA
                    RE RO RS RU RW SA SB SC SD SE SG SH SI SJ SK SL SM
                    SN SO SR SS ST SV SX SY SZ TC TD TF TG TH TJ TK TL
                    TM TN TO TR TT TV TW TZ UA UG UM US UY UZ VA VC VE
                    VG VI VN VU WF WS YE YT ZA ZM ZW).freeze

  belongs_to :user, optional: true
  after_initialize :default_values
  after_initialize :tag_creation

  validates :user_id, :person_type, presence: true
  validates :person_type, inclusion: { in: %w(NATURAL LEGAL) }
  validates :first_name, :last_name, :birthday, :country_of_residence,
            :nationality, presence: true, if: :natural?
  validates :legal_person_type, :legal_name,
            :legal_representative_first_name, :legal_representative_last_name,
            :legal_representative_birthday, :legal_representative_country_of_residence,
            :legal_representative_nationality,
            presence: true, if: :legal?
  validates :country_of_residence,
            :nationality,
            inclusion: { in: COUNTRY_LIST },
            if: :natural?
  validates :legal_representative_country_of_residence, :legal_representative_nationality,
            inclusion: { in: COUNTRY_LIST }, if: :legal?

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

  def tag_creation
    if User.find(user_id).coach_id.nil?
      self.tag ||= "User_id:" + user_id.to_s
    else
      self.tag += "/ Coach_id:" + User.find(user_id).coach_id.to_s
    end
  end
end
