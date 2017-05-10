class CreateBasics < ActiveRecord::Migration[5.0]
  def change
    create_table :basics do |t|
      t.string :customer
      t.string :project
      t.string :pricing
      t.integer :numidentities
      t.integer :userpop
      t.integer :expense
      t.integer :fixedcon

      t.timestamps
    end
  end
end
