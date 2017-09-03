namespace :order do
  desc "Daily check for mangopay transfers to be done from customers' wallets to coaches' wallets "
  task launch_mangopay_transfer: :environment do
    TransferJob.perform_now
  end
end
