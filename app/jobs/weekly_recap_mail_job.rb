class WeeklyRecapMailJob < ApplicationJob
  queue_as :default

# rubocop:disable all
  def perform

    # je sélectionne tous les users à qui sont proposés des activités
    users_to_inform = []


    # je regarde toutes les activités qui ont des activités avec des séances programmées
    courses = Course.all
    live_courses = courses.select { |course| course.next_slots.count.positive?}

    # je regarde tous les utilisateurs qui pourraient réserver ces cours
    live_courses.each do |course|
      users_to_inform << course.group.users
    end

    # j'enlève les éventuels doublons
    users_to_inform = users_to_inform.flatten.uniq

    # J'envoie un mail à chaque utilisateur
    users_to_inform.each do |user|
      UserMailer.weekly_recap_mail(user).deliver_now
    end
  end
end
