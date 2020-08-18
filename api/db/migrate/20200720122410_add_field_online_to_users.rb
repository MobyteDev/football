class AddFieldOnlineToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :online, :boolean, null: false, default: false
  end
end
