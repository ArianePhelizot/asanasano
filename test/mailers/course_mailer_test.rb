require "test_helper"

class CourseMailerTest < ActionMailer::TestCase
  # called before every single test
  setup do
    @user = users(:mary)
    @course = courses(:patin_beginners)
  end

  test "new_published_course" do
    # Create the email and store it for further assertions
    travel_to Date.new(2017, 9, 2) do
      mail = CourseMailer.new_published_course(@user, @course)
      mail.deliver_now

      # Send the email, then test that it got queued
      assert_emails 1 do
        mail.deliver_now
      end
      # Test the body of the sent email contains what we expect it to
      assert_equal "Yippee: Une nouvelle activité de Patin vous est proposée!", mail.subject
      assert_equal ["mary.poppins@gmail.com"], mail.to
      assert_equal ["hello@asanasano.com"], mail.from
      assert_match "Bonjour", mail.body.encoded
    end
  end
end
