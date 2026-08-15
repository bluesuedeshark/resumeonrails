class CreateFamilies < ActiveRecord::Migration[8.1]
  def change
    create_table :families do |t|
      t.string :label
      t.boolean :extended_day
      t.boolean :wants_bus
      t.boolean :carpool_interested

      t.timestamps
    end
  end
end
