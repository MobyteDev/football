class AddColumnRoomToSuperuser < ActiveRecord::Migration[5.1]
  def change
    add_column :superusers, :room_id, :integer, default: 0
    add_index :superusers, :room_id
  end
end
