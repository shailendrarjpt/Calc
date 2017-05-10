class AddCswfarchToIdmAdmin < ActiveRecord::Migration[5.0]
  def change
    add_column :idm_admins, :cswfarch, :integer
  end
end
