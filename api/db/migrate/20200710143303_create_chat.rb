class CreateChat < ActiveRecord::Migration[5.1]
  def change
    create_table :chats do |t|
      t.integer :user_id, null: false
      t.index :user_id
    end
  end
end
