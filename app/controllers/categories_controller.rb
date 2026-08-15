class CategoriesController < ApplicationController
  def show
    @category = Skill.find_by_category_slug!(params[:id])
    @skills = Skill.where(category: @category).order(:name)
    @accomplishments = Accomplishment
      .joins(:skills, :role)
      .where(skills: { category: @category })
      .includes(:role, :skills)
      .distinct
      .order("roles.position DESC, accomplishments.position ASC")
  end
end
