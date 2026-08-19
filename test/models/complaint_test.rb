require "test_helper"

class ComplaintTest < ActiveSupport::TestCase
  test "ordered sorts by logged_on ascending" do
    dates = Complaint.ordered.map(&:logged_on)

    assert_equal dates.sort, dates
  end

  test "belongs to a family" do
    complaint = complaints(:complaint_one)

    assert_equal families(:family_alpha), complaint.family
  end

  test "family is optional" do
    complaint = Complaint.new(logged_on: Date.current, channel: "email", category: "Wait time", severity: 1)

    assert complaint.valid?
  end
end
