class Complaint < ApplicationRecord
  scope :ordered, -> { order(:logged_on) }
end
