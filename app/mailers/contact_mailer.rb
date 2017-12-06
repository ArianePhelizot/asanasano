class ContactMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.order_mailer.order_confirmation.subject

  ASANASANO_CONTACT_EMAIL = "hello@asanasano.com".freeze

  def contact_me(message)
    @message = message

    mail(
      to:         ASANASANO_CONTACT_EMAIL,
      subject:    "Contact de #{@message.email}"
    )
  end
end
