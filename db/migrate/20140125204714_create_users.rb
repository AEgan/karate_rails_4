class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.string :password_digest
      t.string :role
      t.integer :student_id
      t.boolean :active

      t.timestamps
    end
  end
end
