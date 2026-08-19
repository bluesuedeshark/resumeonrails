# Print-only content, kept alongside the web copy rather than replacing it: the
# site's voice and the resume's voice are different jobs, and the web version
# stays exactly as written.
class AddPrintFields < ActiveRecord::Migration[8.1]
  def change
    add_column :profiles, :print_summary, :text
    add_column :roles, :print_bullets, :text
    add_column :roles, :print_condensed, :boolean, default: false, null: false
  end
end
