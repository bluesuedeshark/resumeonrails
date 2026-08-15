class CreateCarlineDays < ActiveRecord::Migration[8.1]
  def change
    create_table :carline_days do |t|
      t.date :observed_on
      t.string :dismissal_time
      t.integer :avg_wait_minutes
      t.integer :worst_wait_minutes
      t.integer :cars_in_line
      t.text :note

      t.timestamps
    end
  end
end
