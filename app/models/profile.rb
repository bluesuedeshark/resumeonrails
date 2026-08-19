class Profile < ApplicationRecord
  def self.current
    first!
  end

  # The printed resume opens with a few tight lines rather than the site's
  # longer, cover-letter-register intro.
  def print_summary_lines
    source = print_summary.presence || intro.to_s
    source.split(/\n+/).map(&:strip).reject(&:blank?)
  end
end
