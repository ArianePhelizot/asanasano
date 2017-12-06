# frozen_string_literal: true

# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative "config/application"
require "rollbar/rake_tasks"

Rails.application.load_tasks

task :environment do
  Rollbar.configure do |config|
    config.access_token = "c7406bb38696440cb9485812a031ce35"
  end
end
