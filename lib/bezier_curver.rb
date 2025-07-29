# frozen_string_literal: true

require 'ruby2d'
require 'bezier_curver/version'
require 'bezier_curver/calculator'
require 'bezier_curver/manager'
require 'bezier_curver/window'

module BezierCurver
  class Error < StandardError; end

  def self.run
    Window.new.show
  end
end
