# frozen_string_literal: true

require 'spec_helper'

RSpec.describe BezierCurver::Manager do
  # Mock Ruby2D classes for testing
  before do
    stub_const('Circle', MockCircle)
    stub_const('Line', MockLine)
  end

  let(:manager) { described_class.new }

  describe '#initialize' do
    it 'starts with empty control points' do
      expect(manager.control_points).to be_empty
    end
  end

  describe '#add_control_point' do
    it 'adds a control point to the array' do
      manager.add_control_point(100, 200)

      expect(manager.control_points).to eq([[100, 200]])
    end

    it 'creates a circle for the control point' do
      expect(Circle).to receive(:new).with(
        x: 100, y: 200, radius: 5, color: 'red', z: 10
      ).and_call_original

      manager.add_control_point(100, 200)
    end

    it 'creates control lines between points' do
      manager.add_control_point(0, 0)

      expect(Line).to receive(:new).with(
        hash_including(x1: 0, y1: 0, x2: 100, y2: 100)
      ).and_call_original

      manager.add_control_point(100, 100)
    end

    context 'with 5 control points' do
      before do
        allow(BezierCurver::Calculator).to receive(:generate_curve_points)
          .and_return([[[0, 0], [50, 50], [100, 0]]])
      end

      it 'draws bezier curves' do
        # Track line creation
        blue_line_created = false

        allow(Line).to receive(:new).and_wrap_original do |original, *args|
          opts = args.first
          blue_line_created = true if opts[:color] == 'blue' && opts[:width] == 2
          original.call(*args)
        end

        5.times { |i| manager.add_control_point(i * 25, 0) }

        expect(blue_line_created).to be true
      end
    end
  end

  describe '#clear_all' do
    before do
      3.times { |i| manager.add_control_point(i * 50, i * 50) }
    end

    it 'clears all control points' do
      manager.clear_all
      expect(manager.control_points).to be_empty
    end

    it 'removes all visual elements' do
      # Collect created objects
      created_circles = []
      created_lines = []

      # Mock Circle creation
      allow(Circle).to receive(:new).and_wrap_original do |original, *args|
        circle = original.call(*args)
        created_circles << circle
        circle
      end

      # Mock Line creation
      allow(Line).to receive(:new).and_wrap_original do |original, *args|
        line = original.call(*args)
        created_lines << line
        line
      end

      # Create a new drawing manager and add points
      test_manager = described_class.new
      3.times { |i| test_manager.add_control_point(i * 50, i * 50) }

      # Clear all
      test_manager.clear_all

      # Verify all elements were removed
      created_circles.each { |circle| expect(circle).to be_removed }
      created_lines.each { |line| expect(line).to be_removed }
    end
  end
end
