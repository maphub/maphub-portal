class AddMapIdColumnToTag < ActiveRecord::Migration
  def change
    add_column :tags, :map_id, :integer

  end
end
