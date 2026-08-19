require "test_helper"

class AccomplishmentTest < ActiveSupport::TestCase
  test "highlighted excludes accomplishments without a metric" do
    assert_not_includes Accomplishment.highlighted, accomplishments(:acc_no_metric)
  end

  test "highlighted excludes accomplishments explicitly hidden" do
    assert_not_includes Accomplishment.highlighted, accomplishments(:acc_hidden)
  end

  test "highlighted orders explicit highlight_order before nil, then position" do
    assert_equal [
      accomplishments(:acc_highlighted),
      accomplishments(:acc_unordered_highlight)
    ], Accomplishment.highlighted.to_a
  end

  test "ordered sorts by position ascending" do
    positions = Accomplishment.ordered.map(&:position)

    assert_equal positions.sort, positions
  end
end
