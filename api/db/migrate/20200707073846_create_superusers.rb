class CreateSuperusers < ActiveRecord::Migration[5.1]
  def change
    create_table :superusers do |t|
      t.string :login, null: false
      t.string :password_digest
      t.string :btn1
      t.string :btn2
      t.string :btn3
      t.string :push_token
      t.string :role
      t.timestamps
    end
    add_column :users, :role, :string
  end
end
