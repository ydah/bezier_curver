# frozen_string_literal: true

module BezierCurver
  class Window
    def initialize
      setup_window
      @manager = Manager.new
      setup_events
      add_instructions
    end

    def show
      ::Window.show
    end

    private

    def setup_window
      ::Window.set title: 'Bezier Curve Drawing Tool'
      ::Window.set width: 800
      ::Window.set height: 600
      ::Window.set background: 'black'
    end

    def setup_events
      ::Window.on :mouse_down do |event|
        @manager.add_control_point(event.x, event.y) if event.button == :left
      end

      ::Window.on :key_down do |event|
        @manager.clear_all if event.key == 'escape'
      end
    end

    def add_instructions
      Text.new(
        'Click: Add control point | ESC: Clear | 4th degree Bezier curve drawn every 5 points',
        x: 10, y: 10,
        size: 14,
        color: 'white'
      )
    end
  end
end
