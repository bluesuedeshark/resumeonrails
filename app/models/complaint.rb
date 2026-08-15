class Complaint < ApplicationRecord
  belongs_to :family, optional: true

  scope :ordered, -> { order(:logged_on) }
end
