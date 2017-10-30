# frozen_string_literal: true

class UserMailer < ApplicationMailer
  helper ApplicationHelper
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.welcome.subject
  #
  def welcome(user)
    @user = user

    mail to: @user.email,
         subject: "Bienvenue #{@user.first_name.capitalize if @user.first_name?} sur Asanasano !"
  end

  def welcome_pro(user)
    @user = user

    mail to: @user.email,
         subject: "Bienvenue #{@user.first_name.capitalize if @user.first_name?} sur Asanasano !"
  end

  def weekly_recap_mail(user)
    @user = user

    # de quoi vais-je avoir besoin en variable

    mail to: @user.email,
         subject: "Et voilà le programme!"
  end
end
