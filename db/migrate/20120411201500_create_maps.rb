class CreateMaps < ActiveRecord::Migration
  def change
    create_table :maps do |t|
      t.string :identifier
      t.string :title
      t.string :subject
      t.integer :width
      t.integer :height
      t.string :author
      t.string :date
      t.float :sw_lat
      t.float :sw_lng
      t.float :ne_lat
      t.float :ne_lng
      
      t.timestamps
    end
  end
end
