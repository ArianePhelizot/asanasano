namespace :coach do
  desc "Coach daily reminder mails for all slots 2 days ahead "
  task coach_mail_reminder: :environment do
    CoachReminderJob.perform_now
  end
end
