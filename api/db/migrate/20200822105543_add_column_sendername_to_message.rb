class AddColumnSendernameToMessage < ActiveRecord::Migration[5.1]
  def change
    add_column :messages, :sender_name, :string, default: ""
    add_column :messages, :sender_avatar, :string, default: ""
  end
end
