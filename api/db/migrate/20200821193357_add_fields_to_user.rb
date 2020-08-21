class AddFieldsToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :surname, :string, default: ""
    add_column :users, :birthday, :string, default: ""
    add_column :users, :gender, :string, default: ""
    add_column :users, :email, :string, default: ""
    add_column :users, :caption, :string, default: ""
    add_column :users, :rank, :float, default: 1.0
    add_index :users, :rank
    add_index :users, :email
    add_index :users, :gender
    add_index :users, :birthday
  end
end
