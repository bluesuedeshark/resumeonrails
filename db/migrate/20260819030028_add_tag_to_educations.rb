class AddTagToEducations < ActiveRecord::Migration[8.1]
  def change
    add_column :educations, :tag, :string
  end
end
