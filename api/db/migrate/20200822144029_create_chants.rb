class CreateChants < ActiveRecord::Migration[5.1]
  def change
    create_table :chants do |t|
    t.string :title, default: ""
    t.text :content, default: ""
    t.timestamps
    end
  end
end
