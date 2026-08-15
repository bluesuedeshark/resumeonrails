class PagesController < ApplicationController
  def home
    @profile = Profile.current
    @roles = Role.ordered.includes(accomplishments: :skills)
  end

  def timeline
    @roles = Role.ordered.includes(accomplishments: :skills)
    @skills = Skill.ordered
  end

  def stats
    @total_years = ((Date.current - Role.minimum(:starts_on)) / 365.25).round
    @accomplishment_count = Accomplishment.count
    @skill_count = Skill.count
    @featured = Accomplishment.where.not(metric: [ nil, "" ]).includes(:role)
  end
end
