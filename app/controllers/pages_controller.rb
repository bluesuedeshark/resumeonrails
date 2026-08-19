class PagesController < ApplicationController
  include CarlineMetrics
  def home
    @profile = Profile.current
    @skill_categories = Skill.categories
    @featured_projects = Accomplishment.highlighted.includes(:role, :skills)
  end

  def timeline
    @roles = Role.ordered.includes(accomplishments: :skills).reverse
    @skills = Skill.ordered
  end

  # One printable document: everything the web version spreads across Headline
  # and Timeline, minus the web-only furniture, plus an optional Carline appendix.
  def print
    @profile = Profile.current
    @roles = Role.ordered.includes(:accomplishments).reverse
    @skills = Skill.ordered
    @education = Education.recent_first
    load_metrics
    render layout: "print"
  end
end
