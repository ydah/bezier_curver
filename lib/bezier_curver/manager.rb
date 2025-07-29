# frozen_string_literal: true

module BezierCurver
  class Manager
    attr_reader :control_points

    def initialize
      @control_points = []
      @point_circles = []
      @curve_lines = []
      @control_lines = []
    end

    def add_control_point(x, y)
      @control_points << [x, y]

      # Display control point
      circle = Circle.new(
        x: x, y: y,
        radius: 5,
        color: 'red',
        z: 10
      )
      @point_circles << circle

      draw_control_lines
      draw_bezier_curves if @control_points.length >= 5
    end

    def clear_all
      @control_points.clear

      @point_circles.each(&:remove)
      @point_circles.clear

      @curve_lines.each(&:remove)
      @curve_lines.clear

      @control_lines.each(&:remove)
      @control_lines.clear
    end

    private

    def draw_bezier_curves
      @curve_lines.each(&:remove)
      @curve_lines.clear

      curve_segments = Calculator.generate_curve_points(@control_points)

      curve_segments.each do |segment|
        segment.each_cons(2) do |p1, p2|
          line = Line.new(
            x1: p1[0], y1: p1[1],
            x2: p2[0], y2: p2[1],
            width: 2,
            color: 'blue'
          )
          @curve_lines << line
        end
      end
    end

    def draw_control_lines
      @control_lines.each(&:remove)
      @control_lines.clear

      @control_points.each_cons(2) do |p1, p2|
        line = Line.new(
          x1: p1[0], y1: p1[1],
          x2: p2[0], y2: p2[1],
          width: 1,
          color: 'gray',
          opacity: 0.5
        )
        @control_lines << line
      end
    end
  end
end
