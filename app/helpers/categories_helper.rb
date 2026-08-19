module CategoriesHelper
  # The single vocabulary for a category, used by both the Timeline roster and
  # the category page's pill row so the two can never drift apart: education
  # credential types first (newest first), then the named skills.
  def category_pills(category)
    education_tags(category) + Skill.where(category: category).order(:name).pluck(:name)
  end

  def education_tags(category)
    Education.for_category(category).filter_map(&:tag).uniq
  end
end
