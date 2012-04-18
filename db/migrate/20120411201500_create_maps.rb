class CreateMaps < ActiveRecord::Migration
  def change
    create_table :maps do |t|
      t.string :identifier
      t.string :title
      t.string :subject
      t.integer :width
      t.integer :height
      t.timestamps
    end
  end
end
