class CreateStudents < ActiveRecord::Migration
  def change
    create_table :students do |t|
      t.string :first_name
      t.string :last_name
      t.string :phone
      t.integer :rank
      t.boolean :waiver_signed
      t.boolean :active
      t.date :date_of_birth

      t.timestamps
    end
  end
end
