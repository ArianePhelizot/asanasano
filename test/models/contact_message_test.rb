require "test_helper"

class ContactMessageTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  test "responds to name, email and body" do
    msg = ContactMessage.new

    assert msg.respond_to?(:name),  "does not respond to :name"
    assert msg.respond_to?(:email), "does not respond to :email"
    assert msg.respond_to?(:body),  "does not respond to :body"
  end

  test "should be valid when all attributes are set" do
    attrs = {
      name: "stephen",
      email: "stephen@example.org",
      company: "Chocolate Factory",
      body: "kthnxbai"
    }

    msg = ContactMessage.new attrs
    assert msg.valid?, "should be valid"
  end
end
