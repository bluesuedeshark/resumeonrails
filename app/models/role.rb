class Role < ApplicationRecord
  has_many :accomplishments, -> { order(:position) }, dependent: :destroy

  scope :ordered, -> { order(position: :asc) }

  # Print uses its own terser bullets where they exist, falling back to the web
  # accomplishments so a role is never silently blank on paper.
  def print_bullet_list
    return print_bullets.split("\n").map(&:strip).reject(&:blank?) if print_bullets.present?

    accomplishments.map(&:description)
  end

  def date_range
    start_label = starts_on&.strftime("%b %Y")
    end_label = current? ? "present" : ends_on&.strftime("%b %Y")
    [ start_label, end_label ].compact.join(" – ")
  end
end
