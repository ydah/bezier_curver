# frozen_string_literal: true

require 'spec_helper'

RSpec.describe 'Bezier Curve Tool Integration' do
  before do
    stub_const('Circle', MockCircle)
    stub_const('Line', MockLine)
  end

  it 'creates a complete bezier curve from 5 control points' do
    drawing_manager = BezierCurver::Manager.new

    # Add 5 control points
    control_points = [
      [0, 100], [50, 0], [100, 0], [150, 0], [200, 100]
    ]

    control_points.each do |x, y|
      drawing_manager.add_control_point(x, y)
    end

    # Verify control points were added
    expect(drawing_manager.control_points).to eq(control_points)

    # Verify curve calculation
    curve_points = BezierCurver::Calculator.generate_curve_points(control_points, 10)
    expect(curve_points).not_to be_empty
    expect(curve_points[0].first).to eq([0, 100])  # Start point
    expect(curve_points[0].last).to eq([200, 100]) # End point
  end

  it 'handles multiple curve segments' do
    drawing_manager = BezierCurver::Manager.new

    # Add 10 control points (2 curves)
    10.times do |i|
      drawing_manager.add_control_point(i * 20, (i % 2) * 100)
    end

    curve_points = BezierCurver::Calculator.generate_curve_points(
      drawing_manager.control_points,
      10
    )

    expect(curve_points.length).to eq(2) # Two curve segments
  end
end
