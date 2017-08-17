# frozen_string_literal: true

if Rails.env.development?
  require 'email_interceptor'
  ActionMailer::Base.register_interceptor(EmailInterceptor)
end
