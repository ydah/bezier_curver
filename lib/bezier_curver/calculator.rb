# frozen_string_literal: true

module BezierCurver
  class Calculator
    # Calculate 4th degree Bezier curve (5 control points)
    def self.calculate_point(p0, p1, p2, p3, p4, t)
      x = (((1 - t)**4) * p0[0]) +
          (4 * ((1 - t)**3) * t * p1[0]) +
          (6 * ((1 - t)**2) * (t**2) * p2[0]) +
          (4 * (1 - t) * (t**3) * p3[0]) +
          ((t**4) * p4[0])

      y = (((1 - t)**4) * p0[1]) +
          (4 * ((1 - t)**3) * t * p1[1]) +
          (6 * ((1 - t)**2) * (t**2) * p2[1]) +
          (4 * (1 - t) * (t**3) * p3[1]) +
          ((t**4) * p4[1])

      [x, y]
    end

    def self.generate_curve_points(control_points, segments = 100)
      points = []

      (0...control_points.length).step(5) do |i|
        next if i + 4 >= control_points.length

        curve_segment = []
        (0..segments).each do |j|
          t = j.to_f / segments
          point = calculate_point(
            control_points[i],
            control_points[i + 1],
            control_points[i + 2],
            control_points[i + 3],
            control_points[i + 4],
            t
          )
          curve_segment << point
        end
        points << curve_segment
      end

      points
    end
  end
end
