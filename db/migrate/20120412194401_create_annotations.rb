class CreateAnnotations < ActiveRecord::Migration
  def change
    create_table :annotations do |t|
      t.string :body
      t.integer :user_id
      t.integer :map_id
      t.string :wkt_data
      t.integer :boundary_bottom
      t.integer :boundary_left
      t.integer :boundary_right
      t.integer :boundary_top
      t.float :sw_lat
      t.float :sw_lng
      t.float :ne_lat
      t.float :ne_lng
      t.timestamps
    end
  end
end
