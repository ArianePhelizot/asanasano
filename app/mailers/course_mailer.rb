class CourseMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.order_mailer.order_confirmation.subject

  def new_published_course(user, course)
    @user = user
    @course = course
    @coach_user = course.coach.user

    mail(
      to:         @user.email,
      subject:    "Yippee: Une nouvelle activité de #{@course.name} vous est proposée!"
    )
  end
end
