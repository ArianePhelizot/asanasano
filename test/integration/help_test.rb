# frozen_string_literal: true

require "test_helper"

class HelpTest < ActionDispatch::IntegrationTest
  test "loads correctly" do
    visit "/help"
    assert_equal 200, page.status_code
    assert page.has_content?("Organisateurs en chef")
  end
end
