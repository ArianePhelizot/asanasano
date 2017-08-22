# configuration
MangoPay.configure do |c|
  c.preproduction = true
  c.client_id = ENV['MANGOPAY_CLIENT_ID']
  c.client_passphrase = ENV['MANGOPAY_PASSPHRASE']
  # c.log_file = File.join('../../log', 'mangopay.log')
  c.http_timeout = 10000
end

# Set MANGOPAY API base URL and Client ID
mangoPay.cardRegistration.baseURL = "https://api.sandbox.mangopay.com";
mangoPay.cardRegistration.clientId = {MANGOPAY_CLIENT_ID};



# COUNTRY LIST à supprimer une fois que la gem country-Select fonctione
# COUNTRY_LIST = %w(AD AE AF AG AI AL AM AO AQ AR AS AT AU AW AX AZ BA
#                   BB BD BE BF BG BH BI BJ BL BM BN BO BQ BR BS BT BV
#                   BW BY BZ CA CC CD CF CG CH CI CK CL CM CN CO CR CU
#                   CV CW CX CY CZ DE DJ DK DM DO DZ EC EE EG EH ER ES
#                   ET FI FJ FK FM FO FR GA GB GD GE GF GG GH GI GL GM
#                   GN GP GQ GR GS GT GU GW GY HK HM HN HR HT HU ID IE
#                   IL IM IN IO IQ IR IS IT JE JM JO JP KE KG KH KI KM
#                   KN KP KR KW KY KZ LA LB LC LI LK LR LS LT LU LV LY
#                   MA MC MD ME MF MG MH MK ML MM MN MO MP MQ MR MS MT
#                   MU MV MW MX MY MZ NA NC NE NF NG NI NL NO NP NR NU
#                   NZ OM PA PE PF PG PH PK PL PM PN PR PS PT PW PY QA
#                   RE RO RS RU RW SA SB SC SD SE SG SH SI SJ SK SL SM
#                   SN SO SR SS ST SV SX SY SZ TC TD TF TG TH TJ TK TL
#                   TM TN TO TR TT TV TW TZ UA UG UM US UY UZ VA VC VE
#                   VG VI VN VU WF WS YE YT ZA ZM ZW).freeze
# # get some user by id
# john = MangoPay::User.fetch(john_id) # => {FirstName"=>"John", "LastName"=>"Doe", ...}


# # update some of his data
# MangoPay::NaturalUser.update(john_id, {'LastName' => 'CHANGED'}) # => {FirstName"=>"John", "LastName"=>"CHANGED", ...}


# # get all users (with pagination)
# pagination = {'page' => 1, 'per_page' => 8} # get 1st page, 8 items per page
# users = MangoPay::User.fetch(pagination) # => [{...}, ...]: list of 8 users data hashes
# pagination # => {"page"=>1, "per_page"=>8, "total_pages"=>748, "total_items"=>5978}

# # pass custom filters (transactions reporting filters)
# filters = {'MinFeesAmount' => 1, 'MinFeesCurrency' => 'EUR', 'MaxFeesAmount' => 1000, 'MaxFeesCurrency' => 'EUR'}
# reports = MangoPay::Report.fetch(filters) # => [{...}, ...]: list of transaction reports between 1 and 1000 EUR

# # get John's bank accounts
# accounts = MangoPay::BankAccount.fetch(john_id) # => [{...}, ...]: list of accounts data hashes (10 per page by default)


# # error handling
# begin
#   MangoPay::NaturalUser.create({})
# rescue MangoPay::ResponseError => ex

#   ex # => #<MangoPay::ResponseError: One or several required parameters are missing or incorrect. [...] FirstName: The FirstName field is required. LastName: The LastName field is required. Nationality: The Nationality field is required.>

#   ex.details # => {
#              #   "Message"=>"One or several required parameters are missing or incorrect. [...]",
#              #   "Type"=>"param_error",
#              #   "Id"=>"5c080105-4da3-467d-820d-0906164e55fe",
#              #   "Date"=>1409048671.0,
#              #   "errors"=>{
#              #     "FirstName"=>"The FirstName field is required.",
#              #     "LastName"=>"The LastName field is required.", ...},
#              #   "Code"=>"400",
#              #   "Url"=>"/v2/.../users/natural"
#              # }
# end
