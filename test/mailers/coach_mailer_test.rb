require "test_helper"

class CoachMailerTest < ActionMailer::TestCase
  # called before every single test
  setup do
    @slot = slots(:slot1)
    @user = users(:amelie)
  end

  test "coach_slot_reminder" do
    # Create the email and store it for further assertions
    mail = CoachMailer.coach_slot_reminder(@slot, @user)
    mail.deliver_now

    # Send the email, then test that it got queued
    assert_emails 1 do
      mail.deliver_now
    end
    # Test the body of the sent email contains what we expect it to
    # rubocop:disable LineLength
    assert_equal "Petit rappel pour votre séance de Patin de après-demain, mardi 5 septembre, à 13h00.", mail.subject
    # rubocop:enable LineLength
    assert_equal ["amelie.poulain@gmail.com"], mail.to
    assert_equal ["hello@asanasano.com"], mail.from
    assert_match "Bonjour", mail.body.encoded
  end
end
