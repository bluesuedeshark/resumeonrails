class PagesController < ApplicationController
  def home
    @profile = Profile.current
    @roles = Role.ordered.includes(accomplishments: :skills)
    @total_years = ((Date.current - Role.minimum(:starts_on)) / 365.25).round
    @accomplishment_count = Accomplishment.count
    @skill_count = Skill.count
  end

  def timeline
    @roles = Role.ordered.includes(accomplishments: :skills).reverse
    @skills = Skill.ordered
  end
end
