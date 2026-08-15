class CarlineDay < ApplicationRecord
  scope :ordered, -> { order(:observed_on) }
end
