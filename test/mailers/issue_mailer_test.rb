require "test_helper"

class IssueMailerTest < ActionMailer::TestCase
  # called before every single test
  setup do
    @order = orders(:ordergeorgesslot1)
    @result_message = "Ah, ah, ah: ça ne marche pas!!!"
  end

  test "payin_failure" do
    # Create the email and store it for further assertions
    mail = IssueMailer.payin_failure(@order, @result_message)
    mail.deliver_now

    # Send the email, then test that it got queued
    assert_emails 1 do
      mail.deliver_now
    end
    # Test the body of the sent email contains what we expect it to
    assert_equal "Echec", mail.subject.split(" ")[0]
    assert_equal ["support@asanasano.com"], mail.to
    assert_equal ["hello@asanasano.com"], mail.from
    assert_match "ALERTE ROUGE", mail.body.encoded
  end

  test "payin_refund_failed" do
    # Create the email and store it for further assertions
    mail = IssueMailer.payin_refund_failed(@order, @result_message)
    mail.deliver_now

    # Send the email, then test that it got queued
    assert_emails 1 do
      mail.deliver_now
    end
    # Test the body of the sent email contains what we expect it to
    assert_equal "Echec", mail.subject.split(" ")[0]
    assert_equal ["support@asanasano.com"], mail.to
    assert_equal ["hello@asanasano.com"], mail.from
    assert_match "ALERTE ROUGE", mail.body.encoded
  end

  test "transfer_failed" do
    # Create the email and store it for further assertions
    mail = IssueMailer.transfer_failed(@order, @result_message)
    mail.deliver_now

    # Send the email, then test that it got queued
    assert_emails 1 do
      mail.deliver_now
    end
    # Test the body of the sent email contains what we expect it to
    assert_equal "Echec", mail.subject.split(" ")[0]
    assert_equal ["support@asanasano.com"], mail.to
    assert_equal ["hello@asanasano.com"], mail.from
    assert_match "ALERTE ROUGE", mail.body.encoded
  end

  test "payout_failure" do
    # Create the email and store it for further assertions
    mail = IssueMailer.payout_failure(@order.slot, @result_message)
    mail.deliver_now

    # Send the email, then test that it got queued
    assert_emails 1 do
      mail.deliver_now
    end
    # Test the body of the sent email contains what we expect it to
    assert_equal "Echec", mail.subject.split(" ")[0]
    assert_equal ["support@asanasano.com"], mail.to
    assert_equal ["hello@asanasano.com"], mail.from
    assert_match "ALERTE ROUGE", mail.body.encoded
  end
end
