require "test_helper"

class FamilyTest < ActiveSupport::TestCase
  test "vocal includes only families with 2 or more complaints" do
    assert_includes Family.vocal, families(:family_alpha)
    assert_includes Family.vocal, families(:family_gamma)
    assert_not_includes Family.vocal, families(:family_beta)
  end
end
