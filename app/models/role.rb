class Role < ApplicationRecord
  has_many :accomplishments, -> { order(:position) }, dependent: :destroy

  scope :ordered, -> { order(position: :asc) }

  def date_range
    start_label = starts_on&.strftime("%b %Y")
    end_label = current? ? "present" : ends_on&.strftime("%b %Y")
    [ start_label, end_label ].compact.join(" – ")
  end
end
