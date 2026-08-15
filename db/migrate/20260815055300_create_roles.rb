class CreateRoles < ActiveRecord::Migration[8.1]
  def change
    create_table :roles do |t|
      t.string :kind
      t.string :title
      t.string :organization
      t.string :location
      t.date :starts_on
      t.date :ends_on
      t.boolean :current
      t.text :summary
      t.integer :position

      t.timestamps
    end
  end
end
