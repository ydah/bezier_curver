# frozen_string_literal: true

require 'spec_helper'

RSpec.describe BezierCurver::Calculator do
  describe '.calculate_point' do
    it 'returns start point when t=0' do
      p0 = [0, 0]
      p1 = [25, 100]
      p2 = [50, 100]
      p3 = [75, 100]
      p4 = [100, 0]

      result = described_class.calculate_point(p0, p1, p2, p3, p4, 0)
      expect(result).to eq([0, 0])
    end

    it 'returns end point when t=1' do
      p0 = [0, 0]
      p1 = [25, 100]
      p2 = [50, 100]
      p3 = [75, 100]
      p4 = [100, 0]

      result = described_class.calculate_point(p0, p1, p2, p3, p4, 1)
      expect(result).to eq([100, 0])
    end

    it 'returns intermediate point when t=0.5' do
      p0 = [0, 0]
      p1 = [0, 100]
      p2 = [50, 100]
      p3 = [100, 100]
      p4 = [100, 0]

      result = described_class.calculate_point(p0, p1, p2, p3, p4, 0.5)
      expect(result[0]).to be_within(0.1).of(50)
      expect(result[1]).to be > 50 # Should be elevated due to control points
    end
  end

  describe '.generate_curve_points' do
    context 'with less than 5 control points' do
      it 'returns empty array' do
        control_points = [[0, 0], [50, 50], [100, 0]]
        result = described_class.generate_curve_points(control_points)
        expect(result).to be_empty
      end
    end

    context 'with exactly 5 control points' do
      it 'returns one curve segment' do
        control_points = [
          [0, 0], [25, 100], [50, 100], [75, 100], [100, 0]
        ]
        result = described_class.generate_curve_points(control_points, 10)

        expect(result.length).to eq(1)
        expect(result[0].length).to eq(11) # 0 to 10 inclusive
      end
    end

    context 'with 10 control points' do
      it 'returns two curve segments' do
        control_points = [
          [0, 0], [10, 50], [20, 50], [30, 50], [40, 0],
          [40, 0], [50, 50], [60, 50], [70, 50], [80, 0]
        ]
        result = described_class.generate_curve_points(control_points, 10)

        expect(result.length).to eq(2)
        expect(result[0].length).to eq(11)
        expect(result[1].length).to eq(11)
      end
    end
  end
end
