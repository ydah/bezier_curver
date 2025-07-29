# frozen_string_literal: true

require 'bundler/setup'
require 'bezier_curver'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

# Mock Ruby2D classes since we can't create actual windows in tests
class MockCircle
  attr_reader :x, :y, :radius, :color, :z

  def initialize(opts = {})
    @x = opts[:x]
    @y = opts[:y]
    @radius = opts[:radius]
    @color = opts[:color]
    @z = opts[:z]
    @removed = false
  end

  def remove
    @removed = true
  end

  def removed?
    @removed
  end
end

class MockLine
  attr_reader :x1, :y1, :x2, :y2, :width, :color, :opacity

  def initialize(opts = {})
    @x1 = opts[:x1]
    @y1 = opts[:y1]
    @x2 = opts[:x2]
    @y2 = opts[:y2]
    @width = opts[:width]
    @color = opts[:color]
    @opacity = opts[:opacity]
    @removed = false
  end

  def remove
    @removed = true
  end

  def removed?
    @removed
  end
end
