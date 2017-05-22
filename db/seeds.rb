#YourModel.last.id + 1

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
puts 'Cleaning database...'
User.destroy_all
Group.destroy_all
Coach.destroy_all
Course.destroy_all
Slot.destroy_all
Sport.destroy_all



puts 'Creating users, groups, coaches, courses, slots and sports...'


# Users seeds

users_attributes = [
  {
    first_name: "Ariane",
    last_name: "PHELIZOT",
    email: "ariane.phelizot@gmail.com",
    password: "azerty",
    phone_number: "0613990061"
  },
  {
    first_name: "Cherine",
    last_name: "ELFADEL",
    email: "cherineelf@gmail.com",
    password: "azerty",
    phone_number: "0671991204"
  },
  {
    first_name: "Faustin",
    last_name: "VEYSSIERE",
    email: "faustin.veyssiere@gmail.com",
    password: "azerty",
    phone_number: "0782095662"
  },
  {
    first_name: "Guillaume",
    last_name: "JAUFFRET",
    email: "guillaume.jauffret@gmail.com",
    password: "azerty",
    phone_number: "0665647375"
  },
  {
    first_name: "Isabelle",
    last_name: "YVAS",
    email: "isabelle.ivas@gmail.com",
    password: "azerty",
    phone_number: "0601020304",
    # coach_id: 2
  },
  {
    first_name: "Veronica",
    last_name: "OBAMA",
    email: "veronica.obama@gmail.com",
    password: "azerty",
    phone_number: "0613990061",
    # coach_id: 1
  },
  {
    first_name: "Mathieu",
    last_name: "BONFILS",
    email: "mathieu.bonfils@gmail.com",
    password: "azerty",
    phone_number: "0616741821",
    # coach_id: 3
  }
]

User.create!(users_attributes)
puts "#{User.count} users created"


#Coaches seeds

coaches_attributes = [
  {
    description: "Je pratique le yoga depuis 25 ans. Je suis à fonds pour vous faire partager ma passion"
  },
  {
    description: "Diplomée en 2010, je donne des cours collectifs et particuliers de yoga hatha, vinyasa et nidra. J'accompagne aussi bien débutants que confirmés"
  },
  {
    description: "Couteau suisse, fan de sport"
  }
]

Coach.create!(coaches_attributes)
puts "#{Coach.count} coaches created"

#Sports seeds

SPORT = ["YOGA", "PILATES", "FITNESS", "STRETCHING", "DANSE", "ART MARTIAL", "REMISE EN FORME", "CHALLENGE", "RUNNING", "PISCINE", "RAQUETTES", "SPORTS CO"]
SPORT.each do |sport|
    Sport.create!({name: sport})
 end

puts "#{Sport.count} sports created"


# Groups seeds

groups_attributes = [
  {
    owner_id: 1,
    name: "Les petites cerises"
  },
  {
    owner_id: 2,
    name: "Les grosses fraises"
  },
  {
    owner_id: 2,
    name: "Les jeunes courgettes"
  }
]

# Group.create!(groups_attributes)
# puts "#{Group.count} groups created"

# #Courses seeds

# courses_attributes = [
#   {
#     name: "Yoga Hatha",
#     content: "Niveau Débutant - Un yoga postural accessible à tous, pour se sentir bien dans son corps et dans sa tête. Chaque posture doit se tenir 3 minutes. Chaque séance finit par 10 minutes de méditation ",
#     details: "Prendre un tapis de yoga et des vêtements souples. NB: vestiaire et douches ",
#     address: "Rue Joseph Biaggi, 13003 Marseille, France",
#     meeting_point: "Dernier étage de l'EMD",
#     capacity_max: 15,
#     status: 1,
#     group_id: 1,
#     coach_id: 2,
#     sport_id: 1,
#   },
#   {
#     name: "Yoga VInyasa",
#     content: "Un yoga dynamqie et régénérant - Cours tout niveau",
#     details: "Venir 10 minutes avant le dabut du cours - NB: vestiaire et douches",
#     address: "Rue Joseph Biaggi, 13003 Marseille, France",
#     meeting_point: "Dernier étage de l'EMD",
#     capacity_max: 15,
#     status: 2,
#     group_id: 1,
#     coach_id: 2,
#     sport_id: 1,
#   },
#   {
#     name: "Préparation Marseille Cassis 2017",
#     content: "Entrainement collectif pour être prêt le 29 octobre 2017: être en condition et progresser sans se blesser pour être prêt le jour J ",
#     details: "Tennis de rigueur!",
#     address: "Rue Joseph Biaggi, 13003 Marseille, France",
#     meeting_point: "Devant la cafétériat",
#     capacity_max: 300,
#     status:2,
#     group_id: 2,
#     coach_id: 3,
#     sport_id: 9,
#   },
#   {
#     name: "Barre au sol",
#     content: "Venez tous dansez!",
#     details: "Ramenez vos tutus",
#     address: "73 La Cannebière",
#     meeting_point: "Dans le hall",
#     capacity_max: 8,
#     status: 3,
#     group_id: 2,
#     coach_id: 3,
#     sport_id: 5,
#   },
#   {
#     name: "Tai Chi Chuan",
#     content: "Tous les matins à 9 heures, venez faire 30 minutes d'exercices avant de commencer votre journée",
#     details: "Venez comme vous êtes",
#     address: "73 La Cannebière",
#     meeting_point: "Devant la machine à café",
#     capacity_max: 30,
#     status: 2,
#     group_id: 2,
#     coach_id: 3,
#     sport_id: 6,
#   }
#  ]

# Course.create!(courses_attributes)
# puts "#{Course.count} courses created"
