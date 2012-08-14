class CreateMaps < ActiveRecord::Migration
  def change
    create_table :maps do |t|
      t.string :identifier
      t.text :title
      t.text :subject
      t.integer :width
      t.integer :height
      t.text :author
      t.string :date
      t.boolean :overlay_available
      t.timestamps
    end
  end
end
