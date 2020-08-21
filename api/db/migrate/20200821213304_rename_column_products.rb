class RenameColumnProducts < ActiveRecord::Migration[5.1]
  def change
    rename_column :products, :picurl, :picture
  end
end
