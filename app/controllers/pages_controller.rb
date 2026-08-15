class PagesController < ApplicationController
  def home
    @profile = Profile.current
    @featured_skills = Skill
      .joins(:accomplishments)
      .group("skills.id")
      .order(Arel.sql("COUNT(accomplishments.id) DESC"))
      .limit(12)
    @featured_projects = Accomplishment
      .where.not(metric: [ nil, "" ])
      .includes(:role, :skills)
      .order(:position)
  end

  def timeline
    @roles = Role.ordered.includes(accomplishments: :skills).reverse
    @skills = Skill.ordered
  end
end
