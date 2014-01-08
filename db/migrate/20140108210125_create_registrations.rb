class CreateRegistrations < ActiveRecord::Migration
  def change
    create_table :registrations do |t|
      t.integer :section_id
      t.integer :student_id
      t.date :date

      t.timestamps
    end
  end
end
