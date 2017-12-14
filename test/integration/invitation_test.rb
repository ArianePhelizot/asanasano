require "test_helper"

class InvitationTest < ActionDispatch::IntegrationTest

  test "loads correctly new invitation form" do
    # set up
    login_as users(:mary)
    @group = groups(:fraises)
    # exercice
    visit new_group_invitation_path(@group.id)
    # verify
    assert_equal 200, page.status_code
    assert page.has_content?("invitation")
    assert page.has_content?("fraises")
  end

end
