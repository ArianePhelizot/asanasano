namespace :iban do
  desc "Daily check for mangopay to program payouts for coaches "
  task mangopay_launch_coach_payout: :environment do
    CoachesPayoutJob.perform_now
  end
end
