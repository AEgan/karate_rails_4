class CreateTournaments < ActiveRecord::Migration
  def change
    create_table :tournaments do |t|
      t.string :name
      t.date :date
      t.integer :min_rank
      t.integer :max_rank
      t.boolean :active

      t.timestamps
    end
  end
end
