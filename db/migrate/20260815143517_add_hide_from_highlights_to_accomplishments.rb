class AddHideFromHighlightsToAccomplishments < ActiveRecord::Migration[8.1]
  def change
    add_column :accomplishments, :hide_from_highlights, :boolean, default: false, null: false
  end
end
