class AddFamilyRefToComplaints < ActiveRecord::Migration[8.1]
  def change
    add_reference :complaints, :family, foreign_key: true
  end
end
