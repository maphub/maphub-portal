class CreateControlPoints < ActiveRecord::Migration
  def change
    create_table :control_points do |t|
      t.string :name
      t.integer :user_id
      t.integer :map_id
      t.string :geonames_id
      t.string :geonames_label
      t.decimal :lat, :precision => 12, :scale => 10
      t.decimal :lng, :precision => 12, :scale => 10
      t.decimal :x
      t.decimal :y
      t.timestamps
    end
  end
end
