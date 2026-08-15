class Education < ApplicationRecord
  scope :ordered, -> { order(position: :asc) }
end
