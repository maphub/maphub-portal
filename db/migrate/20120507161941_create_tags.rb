class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.string :label
      t.string :dbpedia_uri
      t.string :description
      t.integer :annotation_id
      t.string :status
      t.string :enrichment
      t.timestamps
    end
  end
end
