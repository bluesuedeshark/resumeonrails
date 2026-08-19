require "test_helper"

class ProfileTest < ActiveSupport::TestCase
  test "current returns a profile" do
    assert_equal profiles(:primary), Profile.current
  end

  test "current raises when no profile exists" do
    Profile.delete_all

    assert_raises(ActiveRecord::RecordNotFound) { Profile.current }
  end
end
