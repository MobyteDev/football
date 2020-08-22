class ChanegeColumnUsersName < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :name
    add_column :users, :name, :string, default: ""
  end
end
