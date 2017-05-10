class ChangeUserpopToAuthsource < ActiveRecord::Migration[5.0]
  def change
      
    change_table :basics do |t|
      t.rename :userpop, :authsource
    end
  end
end
