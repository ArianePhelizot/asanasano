# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: "hello@asanasano.com"
  layout "mailer"
end
