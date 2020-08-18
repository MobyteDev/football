class AddColumnTypeToMessage < ActiveRecord::Migration[5.1]
  def change
    add_column :messages, :type_message, :integer
  end
end
