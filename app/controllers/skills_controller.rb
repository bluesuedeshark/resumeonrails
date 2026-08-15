class SkillsController < ApplicationController
  def show
    @skill = Skill.all.find { |s| s.to_param == params[:id] } || raise(ActiveRecord::RecordNotFound)
    @accomplishments = @skill.accomplishments.includes(:role).ordered
  end
end
