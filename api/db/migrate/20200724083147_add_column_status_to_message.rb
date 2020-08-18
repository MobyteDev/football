class AddColumnStatusToMessage < ActiveRecord::Migration[5.1]
  def change
    add_column :messages, :status, :boolean, default: false
  end
end
