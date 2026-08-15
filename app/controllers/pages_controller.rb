class PagesController < ApplicationController
  def home
    @profile = Profile.current
    @skill_categories = Skill.categories
    @featured_projects = Accomplishment.highlighted.includes(:role, :skills)
  end

  def timeline
    @roles = Role.ordered.includes(accomplishments: :skills).reverse
    @skills = Skill.ordered
  end
end
