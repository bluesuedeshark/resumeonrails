class AddHighlightOrderToAccomplishments < ActiveRecord::Migration[8.1]
  def change
    add_column :accomplishments, :highlight_order, :integer
  end
end
