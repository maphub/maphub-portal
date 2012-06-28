class AddEnrichmentColumnToTags < ActiveRecord::Migration
  def change
    add_column :tags, :enrichment, :string

  end
end
