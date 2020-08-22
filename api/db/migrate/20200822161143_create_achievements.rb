class CreateAchievements < ActiveRecord::Migration[5.1]
  def change
    create_table :achievements do |t|
      t.string :name, default: ""
      t.string :caption, default: ""
      t.string :picture, default: ""
      t.float :reward, default: 1.0
    end
    add_column :users, :achievements, :jsonb
  end
end
