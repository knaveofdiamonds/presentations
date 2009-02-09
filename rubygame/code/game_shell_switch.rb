require 'rubygems'
require 'rubygame'

include Rubygame

class GameShell
  attr_reader :screen
  
  def initialize(size)
    Rubygame.init
    @clock = Clock.new {|c| c.target_framerate = 40 }
    @queue = EventQueue.new
    @screen = Screen.new(size)
  end

  def run
    @running = true
    while(@running) do step end
    Rubygame.quit()
  end

  protected

  def step
    @queue.fetch_sdl_events
    @queue.each do |event|
      @running = false if event.kind_of? QuitEvent
      handle(event)
    end
    @screen.update
    @clock.tick
  end

  def handle(event)
  end
end
