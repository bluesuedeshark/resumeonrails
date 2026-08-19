require "test_helper"

class CarlineDayTest < ActiveSupport::TestCase
  test "ordered sorts by observed_on ascending" do
    dates = CarlineDay.ordered.map(&:observed_on)

    assert_equal dates.sort, dates
  end
end
