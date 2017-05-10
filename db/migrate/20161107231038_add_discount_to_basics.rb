class AddDiscountToBasics < ActiveRecord::Migration[5.0]
  def change
    add_column :basics, :discount, :integer
  end
end
