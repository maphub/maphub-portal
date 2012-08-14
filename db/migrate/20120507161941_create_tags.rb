class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.string :label
      t.string :dbpedia_uri
      t.text :description
      t.integer :annotation_id
      t.string :status
      t.text :enrichment
      t.timestamps
    end
  end
end
