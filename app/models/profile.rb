class Profile < ApplicationRecord
  def self.current
    first!
  end
end
