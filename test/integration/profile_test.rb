# frozen_string_literal: true

require "test_helper"

class ProfileTest < ActionDispatch::IntegrationTest
  test "loads correctly when fully known Georges" do
    # set up
    login_as users(:georges)
    # exercice
    visit profile_path
    # verify
    assert_equal 200, page.status_code
    assert page.has_content?("Georges")
    assert page.has_content?("Abitbol")
  end

  test "loads correctly when scarcely known Rocky" do
    # set up
    login_as users(:rocky)
    # exercice
    visit profile_path
    # verify
    assert_equal 200, page.status_code
    assert page.has_content?("rocky@balboa.com")
  end
end
