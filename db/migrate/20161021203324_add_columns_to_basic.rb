class AddColumnsToBasic < ActiveRecord::Migration[5.0]
  def change
    add_column :basics, :pmrate, :integer
    add_column :basics, :barate, :integer
    add_column :basics, :archrate, :integer
    add_column :basics, :onconrate, :integer
    add_column :basics, :offconrate, :integer
  end
end
