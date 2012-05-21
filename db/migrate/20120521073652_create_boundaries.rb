class CreateBoundaries < ActiveRecord::Migration
  def change
    create_table :boundaries do |t|
      
      # polymorphic association: http://guides.rubyonrails.org/association_basics.html
      t.references :boundary_object, :polymorphic => true
      
      t.decimal :ne_x, :null => false
      t.decimal :ne_y, :null => false
      t.decimal :sw_x, :null => false
      t.decimal :sw_y, :null => false
      
      t.decimal :ne_lat
      t.decimal :ne_lng
      t.decimal :sw_lat
      t.decimal :sw_lng
      
      t.timestamps
    end
  end
end
