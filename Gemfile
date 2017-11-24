
# frozen_string_literal: true

git_source(:github) do |asanasano|
  asanasano = "#{asanasano}/#{asanasano}" unless asanasano.include?("/")
  "https://github.com/#{asanasano}.git"
end


source 'https://rubygems.org'
ruby '2.3.3'

gem 'devise'
gem 'devise-i18n'
gem 'country_select'
gem 'devise_invitable', '~> 1.7.0'
gem 'figaro'
gem 'jbuilder', '~> 2.0'
gem 'omniauth-facebook'
gem 'pg'
gem 'puma'
gem 'rails', '5.0.3'
gem 'rails-i18n'
gem 'redis'

gem 'annotate'
gem 'autoprefixer-rails'
gem 'bootstrap-sass'
gem 'font-awesome-sass'
gem 'jquery-fileupload-rails'
gem 'jquery-rails'
gem 'money-rails', '~>1'
gem 'pundit'
gem 'sass-rails'
gem 'simple_form'
gem 'mangopay', '~> 3.0', '>= 3.0.29'
gem 'uglifier'

gem 'icalendar'

gem 'carrierwave', '~> 0.11.2'
gem 'cloudinary'
gem 'coffee-rails'

gem 'activeadmin', github: 'activeadmin/activeadmin'
gem 'inherited_resources', github: 'activeadmin/inherited_resources'

gem 'sidekiq'
gem 'sidekiq-failures', '~> 1.0'

group :development do
  gem 'binding_of_caller'
  gem 'guard'
  gem 'guard-brakeman'
  gem 'guard-bundler'
  gem 'guard-minitest'
  gem 'guard-rspec'
  gem 'letter_opener'
  gem 'web-console'
end

group :development, :test do
  gem 'listen', '~> 3.0.5'
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'capybara'
  gem 'launchy'
  gem 'minitest-reporters'
  gem 'poltergeist'
  gem 'faker'
end

