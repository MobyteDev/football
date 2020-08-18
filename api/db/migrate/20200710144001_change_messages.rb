class ChangeMessages < ActiveRecord::Migration[5.1]
  def change
    add_reference :messages, :sender, polymorphic: true, index: true
    add_column :messages, :chat_id, :integer
    add_column :messages, :picture, :string
    add_index :messages, :chat_id
  end
end
