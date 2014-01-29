class AddFieldsToSections < ActiveRecord::Migration
  def change
    add_column :sections, :tournament_id, :integer
    add_column :sections, :location, :string
    add_column :sections, :round_time, :time
  end
end
