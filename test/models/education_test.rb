require "test_helper"

class EducationTest < ActiveSupport::TestCase
  test "ordered sorts by position ascending" do
    assert_equal [ educations(:first_degree), educations(:second_credential) ], Education.ordered.to_a
  end
end
