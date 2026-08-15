class Skill < ApplicationRecord
  CATEGORY_ORDER = [
    "Data Science and Analytics",
    "AI & Dev",
    "Systems & Process",
    "Learning & Credentials"
  ].freeze

  has_many :accomplishment_skills, dependent: :destroy
  has_many :accomplishments, through: :accomplishment_skills
  has_many :roles, -> { distinct }, through: :accomplishments

  scope :ordered, -> { order(:name) }

  def self.categories
    distinct.pluck(:category).sort_by { |c| CATEGORY_ORDER.index(c) || 99 }
  end

  def self.category_slug(category)
    category.parameterize
  end

  def self.find_by_category_slug!(slug)
    categories.find { |c| category_slug(c) == slug } || raise(ActiveRecord::RecordNotFound)
  end

  def category_slug
    self.class.category_slug(category)
  end
end
