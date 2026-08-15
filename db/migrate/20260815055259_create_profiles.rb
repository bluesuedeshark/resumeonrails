class CreateProfiles < ActiveRecord::Migration[8.1]
  def change
    create_table :profiles do |t|
      t.string :name
      t.string :headline
      t.text :tagline
      t.text :intro
      t.string :github_url
      t.string :linkedin_url
      t.string :location

      t.timestamps
    end
  end
end
