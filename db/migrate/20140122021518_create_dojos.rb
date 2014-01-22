class CreateDojos < ActiveRecord::Migration
  def change
    create_table :dojos do |t|
      t.string :name
      t.string :city
      t.string :state
      t.string :street
      t.string :zip
      t.float :latitude
      t.float :longitude
      t.boolean :active

      t.timestamps
    end
  end
end
