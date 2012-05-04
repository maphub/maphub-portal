require 'test_helper'

class ControlPointTest < ActiveSupport::TestCase

  test "control point count" do
    assert_equal 3, ControlPoint.count
  end
  
  test "getting X and Y from known Lat and Lng" do
    
    control_points = ControlPoint.all

    assert_equal(
      ControlPoint.
        compute_xy_from_known_latlng(-49.4369173974526, 42.33239970898038, 
          control_points).collect! {|x| x.to_i}, [617, 404])
    
    assert_equal(
      ControlPoint.
        compute_xy_from_known_latlng(-74.98360209681323, 71.91052729045569,
          control_points).collect! {|x| x.to_i}, [699, 484])
    
    assert_equal(
      ControlPoint.
        compute_xy_from_known_latlng(-32.01647405811647, 119.43088240522445,
          control_points).collect! {|x| x.to_i}, [831, 350])
        
  end

  test "getting Lat and Lng from known X and Y" do
    
    control_points = ControlPoint.all

    lat, lng = ControlPoint.
                compute_latlng_from_known_xy(617, 404, control_points)
    assert_in_delta(lat, -49.4369173974526, 0.5)
    assert_in_delta(lng, 42.33239970898038, 0.5)
        
  end

end
