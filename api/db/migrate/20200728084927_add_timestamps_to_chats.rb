class AddTimestampsToChats < ActiveRecord::Migration[5.1]
  def change
    add_column :chats, :created_at, :datetime, null: false, default: Time.now
    add_column :chats, :updated_at, :datetime, null: false, default: Time.now
  end
end
