class AddKickoffToBasic < ActiveRecord::Migration[5.0]
  def change
    add_column :basics, :kickoff, :string
  end
end
