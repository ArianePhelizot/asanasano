require "test_helper"

class ContactMessageMailerTest < ActionMailer::TestCase

  test "contact_me" do
    message = ContactMessage.new name: "anna",
                                 email: "anna@example.org",
                                 body: "hello, how are you doing?"

    email = ContactMailer.contact_me(message)

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal "Contact de anna@example.org", email.subject
    assert_match /hello, how are you doing?/, email.body.encoded
  end
end
