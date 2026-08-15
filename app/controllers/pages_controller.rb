class PagesController < ApplicationController
  def home
    @profile = Profile.current
    @roles = Role.ordered.includes(accomplishments: :skills)
  end

  def timeline
    @roles = Role.ordered.includes(accomplishments: :skills).reverse
    @skills = Skill.ordered
  end
end
