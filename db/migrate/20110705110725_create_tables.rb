class CreateTables < ActiveRecord::Migration
  def self.up


    # MAPS belong to a USER
    create_table :maps do |t|
      t.string :title, :null => false
      t.text :description
      t.string :tileset_url
      t.integer :views, :default => 0
      t.datetime :creation_date
      t.datetime :edit_date
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
      t.datetime :creation_date
      t.datetime :edit_date
      t.boolean :public
      t.integer :user_id
      t.timestamps
    end
    
    # ANNOTATIONS belong to a USER and a MAP
    create_table :annotations do |t|
      t.string :title
      t.text :body
      t.datetime :creation_date
      t.datetime :edit_date
      t.integer :user_id
      t.integer :map_id
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
  end
end
