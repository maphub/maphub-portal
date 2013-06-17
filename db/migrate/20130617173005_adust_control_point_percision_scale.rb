class AdustControlPointPercisionScale < ActiveRecord::Migration
  
  # added to enable control_point lat/lng values greater than 99.0

  def up
    change_column :control_points, :lat, :decimal, :precision => 13, :scale => 10
    change_column :control_points, :lng, :decimal, :precision => 13, :scale => 10
  end

  def down
    change_column :control_points, :lat, :decimal, :precision => 12, :scale => 10
    change_column :control_points, :lng, :decimal, :precision => 12, :scale => 10
  end
end
