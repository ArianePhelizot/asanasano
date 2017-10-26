require "test_helper"

class GroupsControllerTest < ActionDispatch::IntegrationTest
  test "lets create a new group" do
    login_as users(:rocky)
    visit "/groups/new"
    fill_in "group_name", with: "The Eye of the tiger"
    click_on "Enregistrer"

    assert_equal new_group_course_path(Group.last.id), page.current_path
    assert_text "The Eye of the tiger"
  end
end
