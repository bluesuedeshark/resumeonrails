class Family < ApplicationRecord
  has_many :complaints

  scope :vocal, -> { joins(:complaints).group(:id).having("COUNT(complaints.id) >= 2") }
end
