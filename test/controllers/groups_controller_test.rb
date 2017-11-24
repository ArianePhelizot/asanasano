# == Schema Information
#
# Table name: groups
#
#  id         :integer          not null, primary key
#  name       :string
#  owner_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_groups_on_owner_id  (owner_id)
#

require "test_helper"

class GroupsControllerTest < ActionDispatch::IntegrationTest
  test "lets create a new group" do
    login_as users(:rocky)
    visit "/groups/new"
    fill_in "group_name", with: "The Eye of the tiger"
    click_on "Enregistrer"

    visit "/dashboard"
    assert_text "The Eye of the tiger"
  end
end
