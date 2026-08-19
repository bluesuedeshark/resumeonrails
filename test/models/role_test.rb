require "test_helper"

class RoleTest < ActiveSupport::TestCase
  test "date_range shows present for a current role" do
    role = roles(:current_role)

    assert_equal "Jan 2024 – present", role.date_range
  end

  test "date_range shows the end month for a past role" do
    role = roles(:past_role)

    assert_equal "Jun 2020 – Dec 2023", role.date_range
  end

  test "ordered sorts by position ascending" do
    assert_equal [ roles(:current_role), roles(:past_role) ], Role.ordered.to_a
  end
end
