class RenameTablePost < ActiveRecord::Migration[5.1]
  def change
    rename_table :posts, :products
  end
end
