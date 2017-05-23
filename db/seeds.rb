#YourModel.last.id + 1

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

puts 'Creating users, groups, coaches, courses and sports...'


# SPORT SEEDS

def open_icon(filename)
  File.open(Rails.root.join("db", "icons", filename))
end

sport1 = Sport.create!(name: "YOGA", icon: open_icon("yoga_icon.png"))
sport2 = Sport.create!(name: "PILATES", icon: open_icon("pilates_icon.png"))
sport3 = Sport.create!(name: "FITNESS", icon: open_icon("fitness_icon.png"))
sport4 = Sport.create!(name: "STRETCHING", icon: open_icon("stretching_icon.png"))
sport5 = Sport.create!(name: "DANSE", icon: open_icon("danse_icon.png"))
sport6 = Sport.create!(name: "ART MARTIAL", icon: open_icon("art_martial_icon.png"))
sport7 = Sport.create!(name: "REMISE EN FORME", icon: open_icon("remise_en_forme_icon.png"))
sport8 = Sport.create!(name: "CHALLENGE", icon: open_icon("challenge_icon.png"))
sport9 = Sport.create!(name: "RUNNING", icon: open_icon("running_icon.png"))
sport10 = Sport.create!(name: "PISCINE", icon: open_icon("piscine_icon.png"))
sport11 = Sport.create!(name: "RAQUETTES", icon: open_icon("raquettes_icon.png"))
sport12 = Sport.create!(name: "SPORTS CO", icon: open_icon("sports_co_icon.png"))

puts "#{Sport.count} sports created"


## Following seed must only be run in development environment
exit(0) unless Rails.env.development?


# COACH SEEDS


coach1 = Coach.create!(description: "Je pratique le yoga depuis 25 ans. Je suis à fonds pour vous faire partager ma passion")
coach2 = Coach.create!(description: "Diplomée en 2010, je donne des cours collectifs et particuliers de yoga hatha, vinyasa et nidra. J accompagne aussi bien débutants que confirmés")
coach3 = Coach.create!(description: "Couteau suisse, fan de sport")

puts "#{Coach.count} coaches created"


# USER SEEDS

user1 = User.create!(first_name: "Ariane",
                    last_name: "PHELIZOT",
                    email: "ariane.phelizot@gmail.com",
                    password: "azerty",
                    phone_number: "0613990061"
                    )

user2 = User.create!(first_name: "Cherine",
                  last_name: "ELFADEL",
                  email: "cherineelf@gmail.com",
                  password: "azerty",
                  phone_number: "0671991204"
                  )

user3 = User.create!(first_name: "Faustin",
                    last_name: "VEYSSIERE",
                    email: "faustin.veyssiere@gmail.com",
                    password: "azerty",
                    phone_number: "0782095662"
                    )

user4 = User.create!(first_name: "Guillaume",
                    last_name: "JAUFFRET",
                    email: "guillaume.jauffret@gmail.com",
                    password: "azerty",
                    phone_number: "0665647375"
                  )
user5 = User.create!(first_name: "Isabelle",
                    last_name: "YVAS",
                    email: "isabelle.ivas@gmail.com",
                    password: "azerty",
                    phone_number: "0601020304",
                    coach: coach1
                  )

user6 = User.create!( first_name: "Veronica",
                      last_name: "OBAMA",
                      email: "veronica.obama@gmail.com",
                      password: "azerty",
                      phone_number: "0613990061",
                      coach: coach2
                  )

user7 = User.create!( first_name: "Mathieu",
                    last_name: "BONFILS",
                    email: "mathieu.bonfils@gmail.com",
                    password: "azerty",
                    phone_number: "0616741821",
                    coach: coach3
                  )

puts "#{User.count} users created"

puts "Associating users and coaches"


# GROUPS SEEDS

group1 = Group.create!(owner_id: user1.id, name: "Les petites cerises")
group2 = Group.create!(owner_id: user2.id, name: "Les grosses fraises")
group3 = Group.create!(owner_id: user2.id, name: "Les jeunes courgettes")

puts "#{Group.count} groups created"


# COURSES SEEDS

course1 = Course.create!(name: "Yoga Hatha",
                        content: "Niveau Débutant - Un yoga postural accessible à tous, pour se sentir bien dans son corps et dans sa tête. Chaque posture doit se tenir 3 minutes. Chaque séance finit par 10 minutes de méditation ",
                        details: "Prendre un tapis de yoga et des vêtements souples. NB: vestiaire et douches ",
                        address: "Rue Joseph Biaggi, 13003 Marseille, France",
                        meeting_point: "Dernier étage de l'EMD",
                        capacity_max: 15,
                        status: 0,
                        group_id: group1.id,
                        coach_id: coach2.id,
                        sport_id: sport1.id)

course2 = Course.create!(name: "Préparation Marseille Cassis 2017",
                        content: "Entrainement collectif pour être prêt le 29 octobre 2017: être en condition et progresser sans se blesser pour être prêt le jour J ",
                        details: "Tennis de rigueur!",
                        address: "Rue Joseph Biaggi, 13003 Marseille, France",
                        meeting_point: "Devant la cafétériat",
                        capacity_max: 300,
                        status:1,
                        group_id: group2.id,
                        coach_id: coach3.id,
                        sport_id: sport9.id)


course3 = Course.create!(name: "Barre au sol",
                        content: "Venez tous dansez!",
                        details: "Ramenez vos tutus",
                        address: "73 La Cannebière",
                        meeting_point: "Dans le hall",
                        capacity_max: 8,
                        status: 2,
                        group_id: group2.id,
                        coach_id: coach3.id,
                        sport_id: sport5.id)


course4 = Course.create!(name: "Tai Chi Chuan",
                        content: "Tous les matins à 9 heures, venez faire 30 minutes d'exercices avant de commencer votre journée",
                        details: "Venez comme vous êtes",
                        address: "73 La Cannebière",
                        meeting_point: "Devant la machine à café",
                        capacity_max: 30,
                        status: 1,
                        group_id: group2.id,
                        coach_id: coach3.id,
                        sport_id: sport6.id)

puts "#{Course.count} courses created"


# SLOT SEEDS

# slot1 = Slot.create!(date:
#                     start_at:
#                     end_at:
#                     specificities:
#                     participants_min:
#                     price_cents:
#                     status:
#                     course_id:
#                     )

# slot2 = Slot.create!(date:
#                     start_at:
#                     end_at:
#                     specificities:
#                     participants_min:
#                     price_cents:
#                     status:
#                     course_id:
#                     )

# slot3 = Slot.create!(date:
#                     start_at:
#                     end_at:
#                     specificities:
#                     participants_min:
#                     price_cents:
#                     status:
#                     course_id:
#                     )

# slot4 = Slot.create!(date:
#                     start_at:
#                     end_at:
#                     specificities:
#                     participants_min:
#                     price_cents:
#                     status:
#                     course_id:
#                     )

# slot5 = Slot.create!(date:
#                     start_at:
#                     end_at:
#                     specificities:
#                     participants_min:
#                     price_cents:
#                     status:
#                     course_id:
#                     )

# puts "#{Slot.count} slots created"

