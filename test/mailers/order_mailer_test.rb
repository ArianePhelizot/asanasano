# frozen_string_literal: true

require "test_helper"

class OrderMailerTest < ActionMailer::TestCase

  # called before every single test
    setup do
      @order = orders(:ordergeorgesslot1)
    end

  test "order_confirmation" do
    # Create the email and store it for further assertions
    mail = OrderMailer.order_confirmation(@order)
    mail.deliver_now

   # Send the email, then test that it got queued
      assert_emails 1 do
        mail.deliver_now
      end
    # Test the body of the sent email contains what we expect it to
    assert_equal "Votre séance de Patin du mardi 5 septembre est bien réservée !", mail.subject
    assert_equal ["george@abitbol.com"], mail.to
    assert_equal ["hello@asanasano.com"], mail.from
    assert_match "Bonjour", mail.body.encoded
  end

  test "slot_reminder" do
    # Create the email and store it for further assertions
    mail = OrderMailer.slot_reminder(@order.slot, @order.user)
    mail.deliver_now

   # Send the email, then test that it got queued
      assert_emails 1 do
        mail.deliver_now
      end
    # Test the body of the sent email contains what we expect it to
    assert_equal "Petit rappel pour votre séance de Patin de demain mardi 5 septembre à 13h00.", mail.subject
    assert_equal ["george@abitbol.com"], mail.to
    assert_equal ["hello@asanasano.com"], mail.from
    assert_match "Bonjour", mail.body.encoded
  end

  test "slot_cancellation_with_refund_confirmation" do
    # Create the email and store it for further assertions
    mail = OrderMailer.slot_cancellation_with_refund_confirmation(@order)
    mail.deliver_now

   # Send the email, then test that it got queued
      assert_emails 1 do
        mail.deliver_now
      end
    # Test the body of the sent email contains what we expect it to
    assert_equal "Message de confirmation: annulation de votre séance de Patin du mardi 5 septembre.", mail.subject
    assert_equal ["george@abitbol.com"], mail.to
    assert_equal ["hello@asanasano.com"], mail.from
    assert_match "Bonjour", mail.body.encoded
  end

  test "slot_cancellation_confirmation" do
    # Create the email and store it for further assertions
    mail = OrderMailer.slot_cancellation_confirmation(@order)
    mail.deliver_now

   # Send the email, then test that it got queued
      assert_emails 1 do
        mail.deliver_now
      end
    # Test the body of the sent email contains what we expect it to
    assert_equal "Message de confirmation: annulation de votre séance de Patin du mardi 5 septembre.", mail.subject
    assert_equal ["george@abitbol.com"], mail.to
    assert_equal ["hello@asanasano.com"], mail.from
    assert_match "Bonjour", mail.body.encoded
  end

  test "slot_cancellation_by_orga_information" do
    # Create the email and store it for further assertions
    mail = OrderMailer.slot_cancellation_by_orga_information(@order)
    mail.deliver_now

   # Send the email, then test that it got queued
      assert_emails 1 do
        mail.deliver_now
      end
    # Test the body of the sent email contains what we expect it to
    assert_equal "Tristesse...votre séance de Patin du mardi 5 septembre est annulée.", mail.subject
    assert_equal ["george@abitbol.com"], mail.to
    assert_equal ["hello@asanasano.com"], mail.from
    assert_match "Bonjour", mail.body.encoded
  end
end

