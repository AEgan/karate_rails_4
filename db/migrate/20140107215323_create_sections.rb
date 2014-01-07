class CreateSections < ActiveRecord::Migration
  def change
    create_table :sections do |t|
      t.boolean :active
      t.integer :event_id
      t.integer :max_age
      t.integer :min_age
      t.integer :max_rank
      t.integer :min_rank

      t.timestamps
    end
  end
end
