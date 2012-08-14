class CreateAnnotations < ActiveRecord::Migration
  def change
    create_table :annotations do |t|
      t.text :body
      t.integer :user_id
      t.integer :map_id
      t.string :wkt_data
      t.timestamps
    end
  end
end
