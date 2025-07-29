# frozen_string_literal: true

require 'spec_helper'

RSpec.describe BezierCurver::Window do
  # Mock the global Window module
  before do
    window_mock = double('Window')
    stub_const('Window', window_mock)
    stub_const('Text', double('Text'))
    stub_const('BezierCurver::Manager', double('Manager'))

    allow(Window).to receive(:set)
    allow(Window).to receive(:on)
    allow(Window).to receive(:show)
    allow(Text).to receive(:new)
    allow(BezierCurver::Manager).to receive(:new)
      .and_return(double('drawing_manager'))
  end

  describe '#initialize' do
    it 'sets up the window properties' do
      expect(Window).to receive(:set).with(title: 'Bezier Curve Drawing Tool')
      expect(Window).to receive(:set).with(width: 800)
      expect(Window).to receive(:set).with(height: 600)
      expect(Window).to receive(:set).with(background: 'black')

      described_class.new
    end

    it 'creates a drawing manager' do
      expect(BezierCurver::Manager).to receive(:new)
      described_class.new
    end

    it 'sets up event handlers' do
      expect(Window).to receive(:on).with(:mouse_down)
      expect(Window).to receive(:on).with(:key_down)

      described_class.new
    end

    it 'adds instruction text' do
      expect(Text).to receive(:new).with(
        'Click: Add control point | ESC: Clear | 4th degree Bezier curve drawn every 5 points',
        hash_including(x: 10, y: 10, size: 14, color: 'white')
      )

      described_class.new
    end
  end

  describe '#show' do
    it 'calls Window.show' do
      window = described_class.new

      expect(Window).to receive(:show)
      window.show
    end
  end

  describe 'event handling' do
    let(:drawing_manager) { double('drawing_manager') }
    let(:window) { described_class.new }

    before do
      allow(BezierCurver::Manager).to receive(:new)
        .and_return(drawing_manager)
    end

    it 'handles mouse click events' do
      mouse_handler = nil
      allow(Window).to receive(:on).with(:mouse_down) { |&block| mouse_handler = block }

      described_class.new

      expect(drawing_manager).to receive(:add_control_point).with(150, 250)

      event = double('event', button: :left, x: 150, y: 250)
      mouse_handler.call(event)
    end

    it 'handles escape key events' do
      key_handler = nil
      allow(Window).to receive(:on).with(:key_down) { |&block| key_handler = block }

      described_class.new

      expect(drawing_manager).to receive(:clear_all)

      event = double('event', key: 'escape')
      key_handler.call(event)
    end
  end
end
