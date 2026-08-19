require "test_helper"

class SkillTest < ActiveSupport::TestCase
  test "categories are unique and sorted by CATEGORY_ORDER, not alphabetically" do
    assert_equal [ "Data Science and Analytics", "AI & Dev", "Learning & Credentials" ], Skill.categories
  end

  test "category_slug parameterizes the category name" do
    assert_equal "ai-dev", Skill.category_slug("AI & Dev")
  end

  test "find_by_category_slug! finds the matching category" do
    assert_equal "AI & Dev", Skill.find_by_category_slug!("ai-dev")
  end

  test "find_by_category_slug! raises for an unknown slug" do
    assert_raises(ActiveRecord::RecordNotFound) do
      Skill.find_by_category_slug!("does-not-exist")
    end
  end

  test "instance category_slug matches the class method" do
    assert_equal "ai-dev", skills(:ruby).category_slug
  end
end
