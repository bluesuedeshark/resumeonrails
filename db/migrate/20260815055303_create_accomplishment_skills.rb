class CreateAccomplishmentSkills < ActiveRecord::Migration[8.1]
  def change
    create_table :accomplishment_skills do |t|
      t.references :accomplishment, null: false, foreign_key: true
      t.references :skill, null: false, foreign_key: true

      t.timestamps
    end
  end
end
