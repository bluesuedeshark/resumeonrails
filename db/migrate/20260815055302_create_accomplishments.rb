class CreateAccomplishments < ActiveRecord::Migration[8.1]
  def change
    create_table :accomplishments do |t|
      t.references :role, null: false, foreign_key: true
      t.text :description
      t.string :metric
      t.integer :position

      t.timestamps
    end
  end
end
