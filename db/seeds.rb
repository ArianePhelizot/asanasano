# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
puts 'Cleaning database...'
Slot.destroy_all
Course.destroy_all
Group.destroy_all
User.destroy_all
Coach.destroy_all
Sport.destroy_all
Account.destroy_all
Wallet.destroy_all
Iban.destroy_all
Order.destroy_all
ParamsSet.destroy_all
MangopayLog.destroy_all

puts 'Creating app params_sets, users, groups, coaches, courses and sports, and accounts, wallets, ibans, slots...'

# APP PARAMS SET SEEDS

params_set1 = ParamsSet.create!(name: "Conditions générales de test du #{Date.today}",
                  description:"- 10% de fees pour ASANASANO,
                              - 72h de délai de paiement des coach à l'issue de la séance,
                              - Possibilité d'annuler sans frais avec un préavis de min 24h",
                  fees_on_payout: 0.1,
                  payout_delay_in_days: 3,
                  free_refund_policy_in_hours: 24)

puts "#{ParamsSet.count} params_set(s) created"

# SPORT SEEDS

def open_icon(filename)
  File.open(Rails.root.join('db', 'icons', filename))
end

sport1 = Sport.create!(name: 'yoga', icon: open_icon('yoga_icon.png'))
sport2 = Sport.create!(name: 'pilates', icon: open_icon('pilates_icon.png'))
sport3 = Sport.create!(name: 'fitness', icon: open_icon('fitness_icon.png'))
sport4 = Sport.create!(name: 'stretching', icon: open_icon('stretching_icon.png'))
sport5 = Sport.create!(name: 'danse', icon: open_icon('danse_icon.png'))
sport6 = Sport.create!(name: 'art martial', icon: open_icon('art_martial_icon.png'))
sport7 = Sport.create!(name: 'remise en forme', icon: open_icon('remise_en_forme_icon.png'))
sport8 = Sport.create!(name: 'challenge', icon: open_icon('challenge_icon.png'))
sport9 = Sport.create!(name: 'running', icon: open_icon('running_icon.png'))
sport10 = Sport.create!(name: 'piscine', icon: open_icon('piscine_icon.png'))
sport11 = Sport.create!(name: 'raquettes', icon: open_icon('raquettes_icon.png'))
sport12 = Sport.create!(name: 'sport co', icon: open_icon('sports_co_icon.png'))

puts "#{Sport.count} sports created"

## Following seed must only be run in development environment
# exit(0) unless Rails.env.development?

# COACH SEEDS

coach1 = Coach.create!(description: 'Je pratique le yoga depuis 25 ans. Je suis à fonds pour vous faire partager ma passion', experience: 5, params_set_id: params_set1.id)
coach2 = Coach.create!(description: 'Diplomée en 2010, je donne des cours collectifs et particuliers de yoga hatha, vinyasa et nidra. J accompagne aussi bien débutants que confirmés', experience: 6, params_set_id: params_set1.id)
coach3 = Coach.create!(description: 'Couteau suisse, fan de sport', experience: 3, params_set_id: params_set1.id)

puts "#{Coach.count} coaches created"

puts 'Associating coaches to sports & vice versa'

sport1.coaches = [coach1, coach2]
sport9.coaches = [coach3]
coach3.sports = [sport6, sport10, sport5]

# USER SEEDS

def open_photo(filename)
  File.open(Rails.root.join('db', 'photos', filename))
end


user1 = User.create!(first_name: 'Ariane',
                     last_name: 'PHELIZOT',
                     email: 'ariane.phelizot@gmail.com',
                     password: 'azerty',
                     phone_number: '0613990061',
                     photo: open_photo('ariane_photo.png'),
                     admin: true,
                     agreed_to_terms: true)

user2 = User.create!(first_name: 'Cherine',
                     last_name: 'ELFADEL',
                     email: 'cherineelf@gmail.com',
                     password: 'azerty',
                     photo: open_photo('cherine_photo.png'),
                     phone_number: '0671991204',
                     agreed_to_terms: true)

user3 = User.create!(first_name: 'Faustin',
                     last_name: 'VEYSSIERE',
                     email: 'faustin.veyssiere@gmail.com',
                     password: 'azerty',
                     photo: open_photo('faustin_photo.png'),
                     phone_number: '0782095662',
                     agreed_to_terms: true)

user4 = User.create!(first_name: 'Guillaume',
                     last_name: 'JAUFFRET',
                     email: 'guillaume.jauffret@gmail.com',
                     password: 'azerty',
                     photo: open_photo('guillaume_photo.png'),
                     phone_number: '0665647375',
                     agreed_to_terms: true)

user5 = User.create!(first_name: 'Isabelle',
                     last_name: 'YVAS',
                     email: 'isabelle.ivas@gmail.com',
                     photo: open_photo('isabelle_photo.jpeg'),
                     password: 'azerty',
                     phone_number: '0601020304',
                     coach: coach1,
                     agreed_to_terms: true)

user6 = User.create!(first_name: 'Veronica',
                     last_name: 'OBAMA',
                     email: 'veronica.obama@gmail.com',
                     password: 'azerty',
                     phone_number: '0613990061',
                     photo: open_photo('veronica_photo.jpg'),
                     coach: coach2,
                     agreed_to_terms: true)

user7 = User.create!(first_name: 'Mathieu',
                     last_name: 'BONFILS',
                     email: 'mathieu.bonfils@gmail.com',
                     password: 'azerty',
                     phone_number: '0616741821',
                     photo: open_photo('mathieu_photo.png'),
                     coach: coach3,
                     agreed_to_terms: true)

puts "#{User.count} users created"

puts 'Associating users and coaches'

# GROUPS SEEDS

group1 = Group.create!(owner_id: user1.id, name: 'Le Wagon Marseille')
group2 = Group.create!(owner_id: user2.id, name: 'Le Wagon')
group3 = Group.create!(owner_id: user2.id, name: 'Happy in Paris')

puts "#{Group.count} groups created"

# COURSES SEEDS

course1 = Course.create!(name: 'Yoga Hatha',
                         content: 'Niveau Débutant - Un yoga postural accessible à tous, pour se sentir bien dans son corps et dans sa tête. Chaque posture doit se tenir 3 minutes. Chaque séance finit par 10 minutes de méditation ',
                         details: 'Prendre un tapis de yoga et des vêtements souples. NB: vestiaire et douches ',
                         address: 'Rue Joseph Biaggi, 13003 Marseille, France',
                         meeting_point: "Dernier étage de l'EMD",
                         capacity_max: 15,
                         status: 0,
                         group_id: group1.id,
                         coach_id: coach2.id,
                         sport_id: sport1.id)

course2 = Course.create!(name: 'Mars-Cass 2017',
                         content: 'Entrainement collectif pour être prêt le 29 octobre 2017: être en condition et progresser sans se blesser pour être prêt le jour J ',
                         details: 'Tennis de rigueur!',
                         address: 'Rue Joseph Biaggi, 13003 Marseille, France',
                         meeting_point: 'Devant la cafétériat',
                         capacity_max: 300,
                         status: 1,
                         group_id: group2.id,
                         coach_id: coach3.id,
                         sport_id: sport9.id)

course3 = Course.create!(name: 'Barre au sol',
                         content: 'Venez tous danser!',
                         details: 'Ramenez vos tutus',
                         address: '73 La Cannebière',
                         meeting_point: 'Dans le hall',
                         capacity_max: 8,
                         status: 2,
                         group_id: group2.id,
                         coach_id: coach3.id,
                         sport_id: sport5.id)

course4 = Course.create!(name: 'Tai Chi Chuan',
                         content: "Tous les matins à 9 heures, venez faire 30 minutes d'exercices avant de commencer votre journée",
                         details: 'Venez comme vous êtes',
                         address: '73 La Cannebière',
                         meeting_point: 'Devant la machine à café',
                         capacity_max: 30,
                         status: 1,
                         group_id: group1.id,
                         coach_id: coach3.id,
                         sport_id: sport6.id)

course5 = Course.create!(name: 'Cross fit',
                         content: 'Venez vous faire du mal',
                         details: 'Prévoir des pansements',
                         address: '73 La Cannebière',
                         meeting_point: "En bas de l'immeuble",
                         capacity_max: 15,
                         status: 1,
                         group_id: group1.id,
                         coach_id: coach1.id,
                         sport_id: sport6.id)

puts "#{Course.count} courses created"

puts 'Associating groups and users'

group1.users = [user1, user2, user3, user4, user5, user7]
group1.save
group2.users = [user1, user2, user6]
group2.save
group3.users = [user1, user4, user6, user4]
group3.save

puts 'Associating coaches and groups'

group1.coaches = [coach1, coach2, coach3]
group2.coaches = [coach3]
group3.coaches = [coach1, coach3]

# ACCOUNT SEEDS

account1 = Account.create!(user_id: user1.id,
                          tag: "User_id: " + user1.id.to_s,
                          person_type: "PERSONNE PHYSIQUE",
                          birthday: Date.new(1975, 12, 26),
                          address_line1: "10 rue Oberkampf",
                          postal_code: "75011",
                          city: "PARIS",
                          region: "",
                          country_of_residence: "FR",
                          nationality: "FR")

account2 = Account.create!(user_id: user2.id,
                          tag: "User_id: " + user2.id.to_s,
                          person_type: "PERSONNE PHYSIQUE",
                          birthday: Date.new(1998, 9, 5),
                          address_line1: "4 rue de la Cannebière",
                          postal_code: "13002",
                          city: "MARSEILLE",
                          region: "",
                          country_of_residence: "FR",
                          nationality: "FR")

account3 = Account.create!(user_id: user3.id,
                          tag: "User_id: " + user3.id.to_s,
                          person_type: "PERSONNE PHYSIQUE",
                          birthday: Date.new(1997, 2, 27),
                          address_line1: "6 avenue Mac Mahon",
                          postal_code: "75008",
                          city: "PARIS",
                          region: "",
                          country_of_residence: "FR",
                          nationality: "FR")

account4 = Account.create!(user_id: user4.id,
                          tag: "User_id: " + user4.id.to_s,
                          person_type: "PERSONNE PHYSIQUE",
                          birthday: Date.new(1987, 6, 15),
                          address_line1: "66 rue de Longchamp",
                          postal_code: "75016",
                          city: "PARIS",
                          region: "",
                          country_of_residence: "FR",
                          nationality: "FR")


account5 = Account.create!(user_id: user5.id,
                          tag: "User_id: " + user5.id.to_s + " & Coach_id: " + coach1.id.to_s,
                          person_type: "PERSONNE PHYSIQUE",
                          birthday: Date.new(1971, 11, 30),
                          address_line1: "2 rue Eugène Carrière",
                          postal_code: "75018",
                          city: "PARIS",
                          region: "",
                          country_of_residence: "FR",
                          nationality: "FR")

account6 = Account.create!(user_id: user6.id,
                          tag: "User_id: " + user6.id.to_s + " & Coach_id: " + coach2.id.to_s,
                          person_type: "PERSONNE PHYSIQUE",
                          birthday: Date.new(1993, 5, 8),
                          address_line1: "15 boulevard de Grenelle",
                          postal_code: "75015",
                          city: "PARIS",
                          region: "",
                          country_of_residence: "FR",
                          nationality: "FR")

account7 = Account.create!(user_id: user7.id,
                          tag: "User_id: " + user7.id.to_s + " & Coach_id: " + coach3.id.to_s,
                          person_type: "PERSONNE PHYSIQUE",
                          birthday: Date.new(1995, 7, 11),
                          address_line1: "165 rue de Paradis",
                          postal_code: "75002",
                          city: "MARSEILLE",
                          region: "",
                          country_of_residence: "FR",
                          nationality: "FR")

  Account.all.each do |account|
        mangopay_user = MangoPay::NaturalUser.create(
        "Tag": account.tag,
        "Email": account.user.email,
        "FirstName": account.first_name,
        "LastName": account.last_name,
        # Pb de format quand champ vide car il me faut a minima un caractère
        "Address":
        { "AddressLine1": account.address_line1,
          "AddressLine2": account.address_line2,
          "City": account.city,
          "Region": account.region,
          "PostalCode": account.postal_code,
          "Country": account.country_of_residence },
        "Birthday": account.birthday.to_time.to_i,
        "Nationality": account.nationality,
        "CountryOfResidence": account.country_of_residence
      )

      account.mangopay_id = mangopay_user["Id"]
      account.save

      MangopayLog.create(event: "natural_account_creation", mangopay_answer: mangopay_user, user_id: account.user.id.to_i )
  end

puts "#{Account.count} accounts created"


# WALLET SEEDS

  Account.all.each do |account|

    wallet = Wallet.create(account_id: account.id, tag: account.tag)

      # Wallet creation by Mangpay
      mangopay_wallet = MangoPay::Wallet.create(
        "Tag": wallet.tag,
        "Owners": [Account.find(wallet.account_id).mangopay_id], # mangopay_id de l'account
        "Description": "ASANASANO Wallet",
        "Currency": "EUR"
      )

      # Recuperation of the Mangopay Id created for the wallet
      wallet.mangopay_id = mangopay_wallet["Id"]
      wallet.save


      MangopayLog.create(event: "wallet_creation",
                        mangopay_answer: mangopay_wallet,
                        user_id: account.user.id.to_i)
  end

puts "#{Wallet.count} wallets created"


# IBAN SEEDS

iban1 = Iban.create(account_id: user5.account.id, iban: "FR7630001007941234567890185")
iban2 = Iban.create(account_id: user6.account.id, iban: "FR7630004000031234567890143" )
iban3 = Iban.create(account_id: user7.account.id, iban: "FR7630006000011234567890189")

  Iban.all.each do |iban|

     # créer l'IBAN chez Mangopay
      mangopay_iban_bankaccount = MangoPay::BankAccount.create(
        iban.account.user.account.mangopay_id,
        { Type: "IBAN",
      OwnerName: [iban.account.user.first_name, iban.account.user.last_name].join(" "),
      OwnerAddress: iban.account.user.account.address,
      IBAN: iban.account.user.account.iban.iban,
      Tag: "Bank account of #{iban.account.user.account.iban.tag}" }
      )

      # updater l'IBAN avec les données de MangoPay
      iban.mangopay_id = mangopay_iban_bankaccount["Id"]
      iban.active = mangopay_iban_bankaccount["Active"]
      iban.save

      MangopayLog.create(event: "iban_creation",
                          mangopay_answer: mangopay_iban_bankaccount,
                          user_id: iban.account.user.id.to_i)
  end

puts "#{Iban.count} ibans created"

# SLOT SEEDS

for i in -7..7
  Slot.create!(date: Date.today + i,
            start_at: DateTime.new((Date.today+i).year, (Date.today+i).month, (Date.today+i).day, 12, 00),
            end_at: DateTime.new((Date.today+i).year, (Date.today+i).month, (Date.today+i).day, 12, 45),
            specificities: "Des matelas seront sur place! Pensez juste à prendre des tenues confortables",
            participants_min: 5,
            price_cents: 1000,
            status: 0,
            course_id: course1.id
            )
end


def date_of_next(day)
  date  = Date.parse(day)
  delta = date > Date.today ? 0 : 7
  date + delta
end


for i in -4..4
  date = date_of_next("Tuesday") + 7*i
  Slot.create!(date: date,
              start_at: DateTime.new(date.year, date.month, date.day, 18, 00),
              end_at: DateTime.new(date.year, date.month, date.day, 19, 15),
              specificities: "Prévoyez juste de bonnes baskets!",
              participants_min: 3,
              price_cents: 500,
              status: 0,
              course_id: course2.id
              )
end



for i in -4..4
  date = date_of_next("Thursday") + 7*i
  Slot.create!(date: date,
              start_at: DateTime.new(date.year, date.month, date.day, 13, 00),
              end_at: DateTime.new(date.year, date.month, date.day, 14, 00),
              specificities: "Prévoyez juste de bonnes baskets!",
              participants_min: 3,
              price_cents: 500,
              status: 0,
              course_id: course5.id
              )
end


for i in -4..4
  date = date_of_next("Wednesday") + 7*i
  Slot.create!(date: date,
              start_at: DateTime.new(date.year, date.month, date.day, 13, 00),
              end_at: DateTime.new(date.year, date.month, date.day, 13, 45),
              specificities: "Merci de venir 5 minutes avant le début de la séance pour que nous puissions commencer à l'heure",
              participants_min: 6,
              price_cents: 1500,
              status: 0,
              course_id: course4.id
              )
end

puts "#{Slot.count} slots created"
