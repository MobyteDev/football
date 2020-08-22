class CreateCategoryes < ActiveRecord::Migration[5.1]
  def change
    create_table :categories do |t|
      t.string :name
      t.integer :icon_index
    end
  end
end
