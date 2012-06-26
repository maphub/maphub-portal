class RemoveMapIdFromTags < ActiveRecord::Migration
  def up
    remove_column :tags, :map_id
      end

  def down
    add_column :tags, :map_id, :integer
  end
end
