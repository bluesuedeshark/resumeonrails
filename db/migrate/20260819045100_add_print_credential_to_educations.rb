class AddPrintCredentialToEducations < ActiveRecord::Migration[8.1]
  def change
    add_column :educations, :print_credential, :string
  end
end
