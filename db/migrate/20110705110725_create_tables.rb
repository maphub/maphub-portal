class CreateTables < ActiveRecord::Migration
  def self.up


    # MAPS belong to a USER
    create_table :maps do |t|
      t.string :title, :null => false
      t.text :description
      t.string :tileset_url
      t.integer :views, :default => 0
      t.datetime :map_date
      t.boolean :public
      t.integer :user_id
      t.integer :width
      t.integer :height
      t.timestamps
    end

    # COLLECTIONS belong to a USER
    create_table :collections do |t|
      t.string :title
      t.text :description
      t.boolean :public
      t.integer :user_id
      t.timestamps
    end
    
    # ANNOTATIONS belong to a USER and a MAP
    create_table :annotations do |t|
      t.string :title
      t.text :body
      t.integer :user_id
      t.integer :map_id
      t.string :wkt_data
      t.timestamps
    end
    
    # CONTROLPOINTS belong to a USER and a MAP
     create_table :control_points do |t|
      t.string :name
      t.string :countryCode
      t.integer :user_id
      t.integer :map_id
      t.string :geonames_uri
      t.decimal :lat, :precision => 12, :scale => 10
      t.decimal :lng, :precision => 12, :scale => 10
      t.decimal :x
      t.decimal :y
      t.timestamps
    end

    create_table :collections_maps, :id => false do |t|
      t.integer :collection_id
      t.integer :map_id
    end

  end

  def self.down
    drop_table :maps
    drop_table :collections
    drop_table :annotations
    drop_table :control_points
    drop_table :collections_maps
  end
end
