namespace :user do
  desc "Weekly reminder mail for future sessions available "
  task weekly_recap_mail: :environment do
    WeeklyRecapMailJob.perform_now
  end
end
