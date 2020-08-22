class AddColumnToChant < ActiveRecord::Migration[5.1]
  def change
    add_column :chants, :duration, :integer, default: 1
  end
end
