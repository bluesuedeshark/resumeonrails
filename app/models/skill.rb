class Skill < ApplicationRecord
  has_many :accomplishment_skills, dependent: :destroy
  has_many :accomplishments, through: :accomplishment_skills
  has_many :roles, -> { distinct }, through: :accomplishments

  scope :ordered, -> { order(:category, :name) }

  def to_param
    name.parameterize
  end
end
