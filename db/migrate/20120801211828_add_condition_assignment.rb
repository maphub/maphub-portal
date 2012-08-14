class AddConditionAssignment < ActiveRecord::Migration
  def change
    add_column :users, :condition_assignment, :string
    add_column :annotations, :condition, :string
  end
end
