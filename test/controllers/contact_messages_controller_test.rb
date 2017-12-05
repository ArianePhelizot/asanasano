require "test_helper"

class ContactMessagesControllerTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  test "GET new" do
    get new_contact_message_url

    assert_response :success

    assert_select "form" do
      assert_select "input[type=text]"
      assert_select "input[type=email]"
      assert_select "textarea"
      assert_select "input[type=submit]"
    end
  end
end
