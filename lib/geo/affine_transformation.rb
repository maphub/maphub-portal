# Implements an affine transformation that converts between two cartesion
# coordinates (map image coordinates and geo-coordinates) based on 
# Control Points. 

# Author: Rainer Simon (original Java Code: https://github.com/yuma-annotation/client-suite/blob/master/src/main/java/at/ait/dme/yuma/suite/apps/map/server/geo/transformation/AffineTransformation.java)

# Author: Bernhard Haslhofer (Rubyfication)

class AffineTransformation
  
  # LAT/LON and X/Y are assumed to be related via an affine transform.
  # An affine transform takes the form
  # 
  #   x = a * u + b * v + c
  #   y = d * u + e * v + f
  # 
  # where x and y are the point's unknown X/Y coordinates (image space);
  # and u and v are the point's known geographical coordinates (u = lat,
  # v = lon). Coefficients a, b, c, d, e, f can be computed if three
  # control points are known (in image space and geo-coordinate space).
  # 
  # The known coordinates of the three control points are denoted as
  # 
  # CP1: x1/y1 (image space) u1/v1 (lat/lon)
  # CP2: x2/y2               u2/v2
  # CP3: x3/y3               u3/v3 
  def self.compute_XY_from_known_latlng(lat, lng, control_points)
    raise ArgumentError unless control_points.length != 3
    
    # Compute matrix coefficients
    x1 = control_points[0].x;
    y1 = control_points[0].y;
    x2 = control_points[1].x;
    y2 = control_points[1].y;
    x3 = control_points[2].x;
    y3 = control_points[2].y;

    u1 = control_points[0].lat; 
    v1 = control_points[0].lng;
    u2 = control_points[1].lat;
    v2 = control_points[1].lng;
    u3 = control_points[2].lat;
    v3 = control_points[2].lng;

    a = (x2 * (v3 - v1) - x3 * (v2 - v1) - x1 * (v3 - v2))/((u2 - u1) * (v3 - v1) - (u3 - u1) * (v2 - v1));
    b = (x2 * (u3 - u1) - x3 * (u2 - u1) - x1 * (u3 - u2))/((v2 - v1) * (u3 - u1) - (v3 - v1) * (u2 - u1));
    c = x1 - a * u1 - b * v1;

    d = (y2 * (v3 - v1) - y3 * (v2 - v1) - y1 * (v3 - v2))/((u2 - u1) * (v3 - v1) - (u3 - u1) * (v2 - v1));
    e = (y2 * (u3 - u1) - y3 * (u2 - u1) - y1 * (u3 - u2))/((v2 - v1) * (u3 - u1) - (v3 - v1) * (u2 - u1));
    f = y1 - d * u1 - e * v1;

    # Compute transform
    x = a * lat + b * lng + c;
    y = d * lat + e * lng + f;

    return x, y
  end
  
end

