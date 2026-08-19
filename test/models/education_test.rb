require "test_helper"

class EducationTest < ActiveSupport::TestCase
  test "ordered sorts by position ascending" do
    assert_equal [ educations(:first_degree), educations(:second_credential) ], Education.ordered.to_a
  end

  test "headline leads with the credential when it says more than the tag" do
    e = educations(:first_degree)

    assert_equal "B.S. Computer Science", e.headline
    assert_equal "State University · Austin, TX · 2018", e.context_line
  end

  test "headline falls back to the institution when the credential just repeats the tag" do
    e = educations(:second_credential)

    assert_equal "Community College", e.headline
    assert_equal "2015", e.context_line
  end
end
