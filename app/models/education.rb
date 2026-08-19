class Education < ApplicationRecord
  # Education isn't a Skill, but it belongs to the same category vocabulary --
  # a degree and a FINRA license are both credentials.
  CATEGORY = "Learning & Credentials".freeze

  scope :ordered, -> { order(position: :asc) }
  scope :recent_first, -> { order(position: :desc) }

  def self.for_category(category)
    category == CATEGORY ? recent_first : none
  end

  # On paper the institution is what gets emphasised, so the credential runs
  # alongside it as plain text -- and may be a shorter, print-only version.
  def print_credential_text
    print_credential.presence || credential
  end

  def print_meta
    [ location, completed_on&.year ].compact_blank.join(" · ")
  end

  # Card headline. When the credential says nothing the tag pill doesn't already
  # say ("Coursework"), the institution is the specific bit worth leading with.
  def headline
    redundant_credential? ? institution : credential
  end

  # Institution · location · year, minus whatever the headline already used.
  def context_line
    parts = []
    parts << institution unless redundant_credential?
    parts << location if location.present?
    parts << completed_on.year if completed_on.present?
    parts.join(" · ")
  end

  private

  def redundant_credential?
    credential.present? && tag.present? && credential.casecmp?(tag)
  end
end
