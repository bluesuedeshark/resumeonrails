class CreateEducations < ActiveRecord::Migration[8.1]
  def change
    create_table :educations do |t|
      t.string :institution
      t.string :credential
      t.string :honor
      t.string :location
      t.date :completed_on
      t.integer :position

      t.timestamps
    end
  end
end
