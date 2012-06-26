class RemoveSelectedColumnFromTags < ActiveRecord::Migration
  def up
    remove_column :tags, :selected
      end

  def down
    add_column :tags, :selected, :integer
  end
end
