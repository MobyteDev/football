class AddBasketToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :basket, :jsonb 
  end
end
