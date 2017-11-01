# frozen_string_literal: true

require "test_helper"

class CourseTest < ActionDispatch::IntegrationTest
  test "loads correctly" do
    # set up
    travel_to DateTime.new(2017, 9, 6, 8, 0) do
      login_as users(:georges)
      # exercice
      visit course_path(Course.last)
      # verify
      assert_equal 200, page.status_code
      assert page.has_content?("Amélie")
      assert page.has_content?("jeudi 7 septembre")
      assert page.has_content?("PATIN")
    end
  end
end
