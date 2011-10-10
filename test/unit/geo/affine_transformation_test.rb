require 'test_helper'

class AffineTransformationTest < ActiveSupport::TestCase
  
  # Replace this with your real tests.
  test "getting X and Y from known latitude and longitude" do
    #require 'affine_transformation'
    
    cp1 = ControlPoint.new
    cp1.lat = 80
    cp1.lng = -180
    cp1.x = 0
    cp1.y = 0

    cp2 = ControlPoint.new
    cp2.lat = 80
    cp2.lng = 180
    cp2.x = 1000
    cp2.y = 0

    cp3 = ControlPoint.new
    cp3.lat = -80
    cp3.lng = 0
    cp3.x = 500
    cp3.y = 500
    
    control_points = []
    control_points << cp1
    control_points << cp2
    control_points << cp3

    assert_equal(
      AffineTransformation.
        compute_XY_from_known_latlng(-49.4369173974526, 42.33239970898038, control_points).collect! {|x| x.to_i}, [617, 404])

    assert_equal(
      AffineTransformation.
        compute_XY_from_known_latlng(-74.98360209681323, 71.91052729045569, control_points).collect! {|x| x.to_i}, [699, 484])

    assert_equal(
      AffineTransformation.
        compute_XY_from_known_latlng(-32.01647405811647, 119.43088240522445, control_points).collect! {|x| x.to_i}, [831, 350])


        
  end
  
end
