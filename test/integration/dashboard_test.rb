# frozen_string_literal: true

require "test_helper"

class DashboardTest < ActionDispatch::IntegrationTest
  test "loads correctly" do
    # set up
    travel_to DateTime.new(2017, 9, 6, 8, 0) do
      login_as users(:georges)
      # exercice
      visit "/dashboard"
      # verify
      assert_equal 200, page.status_code
      assert page.has_content?("fraises")
      assert page.has_content?("pommes")
      assert page.has_content?("Patin")
      assert page.has_content?("Amélie")
    end
  end
end
