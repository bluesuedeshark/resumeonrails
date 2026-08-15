class Accomplishment < ApplicationRecord
  belongs_to :role
  has_many :accomplishment_skills, dependent: :destroy
  has_many :skills, through: :accomplishment_skills

  scope :ordered, -> { order(:position) }
  scope :highlighted, -> {
    where.not(metric: [ nil, "" ])
      .order(Arel.sql("CASE WHEN highlight_order IS NULL THEN 1 ELSE 0 END, highlight_order, position"))
  }
end
