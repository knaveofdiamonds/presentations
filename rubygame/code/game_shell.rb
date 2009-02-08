require 'rubygems'
require 'rubygame'

include Rubygame
include Events
include EventTriggers
include EventActions

class GameShell
  include EventHandler::HasEventHandler
  attr_reader :screen
  
  def initialize(size)
    Rubygame.init
    @clock = Clock.new {|c| c.target_framerate = 40 }
    @queue = EventQueue.new
    @queue.enable_new_style_events
    make_magic_hooks(QuitRequested => lambda { @running = false })
    @screen = Screen.new(size)
  end

  def run
    @running = true
    while(@running) do step end
    Rubygame.quit()
  end

  # Register the object to receive all events.
  # Events will be passed to the object's #handle method.
  def register( *objects )
    objects.each do |object|
      append_hook( :owner   => object, 
                   :trigger => YesTrigger.new, 
                   :action  => MethodAction.new(:handle) )
    end
  end

  protected

  def step
    @queue.fetch_sdl_events
    @queue.each {|event| handle(event) }
    @screen.update
    @clock.tick
  end
end
