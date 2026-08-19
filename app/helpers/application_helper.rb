module ApplicationHelper
  # The purple pill vocabulary, defined once so every surface that shows a
  # skill, credential, or category renders it identically.
  #
  #   :skill     - clickable inline tag (timeline entries, and the "Skills" link
  #                that points at them, so the word looks like what it describes)
  #   :category  - clickable category chip (home + timeline roster headings)
  #   :static    - non-clickable tag on a category page card
  #   :static_lg - non-clickable tag in a category page's header row
  PILL_CLASSES = {
    skill: "inline-block text-xs bg-purple-50 hover:bg-purple-100 text-purple-700 rounded-full px-2 py-0.5",
    category: "inline-block text-sm bg-purple-50 border border-purple-200 hover:border-purple-400 hover:bg-purple-100 text-purple-700 rounded-full px-4 py-1.5 font-medium",
    static: "inline-block text-xs bg-purple-100 text-purple-700 rounded-full px-2 py-0.5 font-medium",
    static_lg: "inline-block text-xs bg-purple-100 text-purple-700 rounded-full px-2.5 py-1 font-medium"
  }.freeze

  def pill_class(variant = :skill)
    PILL_CLASSES.fetch(variant)
  end
end
