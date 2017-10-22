# frozen_string_literal: true

require "test_helper"

class UserMailerTest < ActionMailer::TestCase
  # called before every single test
  setup do
    @user = users(:mary)
    @user_bis= users(:georges)
  end

  test "welcome" do
    # Create the email and store it for further assertions
    mail = UserMailer.welcome(@user)
    mail.deliver_now

    # Send the email, then test that it got queued
    assert_emails 1 do
      mail.deliver_now
    end

    # Test the body of the sent email contains what we expect it to
    assert_equal "Bienvenue Mary sur Asanasano !", mail.subject
    assert_equal ["mary.poppins@gmail.com"], mail.to
    assert_equal ["hello@asanasano.com"], mail.from
    assert_match "Bonjour", mail.body.encoded
  end

  test "weekly_recap_mail" do
    travel_to Date.new(2017, 9, 2) do
      # Create the email and store it for further assertions
      mail = UserMailer.weekly_recap_mail(@user_bis)
      mail.deliver_now

      # Send the email, then test that it got queued
      assert_emails 1 do
        mail.deliver_now
      end
      # Test the body of the sent email contains what we expect it to
      # rubocop:disable LineLength
      assert_equal "Et voilà le programme!", mail.subject
      # rubocop:enable LineLength
      assert_equal ["georges@abitbol.com"], mail.to
      assert_equal ["hello@asanasano.com"], mail.from
      assert_match "Bonjour", mail.body.encoded
    end
  end
end
