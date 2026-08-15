class CreateComplaints < ActiveRecord::Migration[8.1]
  def change
    create_table :complaints do |t|
      t.date :logged_on
      t.string :channel
      t.string :category
      t.integer :severity
      t.string :family_label

      t.timestamps
    end
  end
end
