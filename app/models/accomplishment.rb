class Accomplishment < ApplicationRecord
  belongs_to :role
  has_many :accomplishment_skills, dependent: :destroy
  has_many :skills, through: :accomplishment_skills

  scope :ordered, -> { order(:position) }
end
