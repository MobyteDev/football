class CreateDishes < ActiveRecord::Migration[5.1]
  def change
    create_table :posts do |t|
      t.string :title
      t.text :content
      t.string :picurl
      t.string :caption1
      t.timestamps
    end
  end
end
