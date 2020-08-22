class RenameColumnProducts < ActiveRecord::Migration[5.1]
  def change
    rename_column :products, :picurl, :picture
    add_column :products, :name, :string
    add_column :products, :subname, :string
    add_column :products, :price, :string, null: false
    add_column :products, :category_id, :integer
    add_index :products, :category_id
    remove_column :products, :title
    remove_column :products, :content
  end
end
