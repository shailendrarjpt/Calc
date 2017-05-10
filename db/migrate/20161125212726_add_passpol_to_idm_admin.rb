class AddPasspolToIdmAdmin < ActiveRecord::Migration[5.0]
  def change
    add_column :idm_admins, :passpol, :integer
  end
end
