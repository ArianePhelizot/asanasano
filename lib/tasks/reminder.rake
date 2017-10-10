namespace :user do
  desc "Daily reminder mails for next day bookings "
  task day_before_mail_reminder: :environment do
    MailReminderJob.perform_now
  end
end
