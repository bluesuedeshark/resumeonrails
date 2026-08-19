require "test_helper"

class AccomplishmentSkillTest < ActiveSupport::TestCase
  test "resolves both sides of the join" do
    join = accomplishment_skills(:highlighted_ruby)

    assert_equal accomplishments(:acc_highlighted), join.accomplishment
    assert_equal skills(:ruby), join.skill
  end

  test "an accomplishment reaches its skills through the join" do
    assert_includes accomplishments(:acc_highlighted).skills, skills(:ruby)
    assert_includes accomplishments(:acc_highlighted).skills, skills(:sql)
  end
end
