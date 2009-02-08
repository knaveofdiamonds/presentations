require 'rubygems'
require 'rubygame'

include Rubygame
include Events
include EventTriggers
include EventActions

# Game Over event
GameOver = Struct.new(:winner)

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

class Paddle
  include Sprites::Sprite
  include EventHandler::HasEventHandler

  def initialize(max_x, speed)
    super()
    @image = Surface.new([50,10])
    @image.fill([0xff] * 3)
    @rect = @image.make_rect
    @max_x = max_x - rect.width
    @speed = speed
    @vx = 0
  end

  def move_left
    @vx = -1
  end

  def move_right
    @vx = 1
  end

  def stop_moving
    @vx = 0
  end

  def move
    if (0..@max_x).include?( rect.x + (@vx * @speed) )
      rect.x += (@vx * @speed)
    end
  end

  def update
    move
  end
end

class Ball
  include Sprites::Sprite
  attr_accessor :vx, :vy
  def initialize
    super
    @image = Surface.new([9,9])
    @image.draw_circle_a([4,4],4,[0xff]*3)
    @image.draw_circle_s([4,4],4,[0xff]*3)
    @rect  = @image.make_rect
    @vx, @vy = 3,4
    @bounce = 1.1
  end

  def update
    rect.x, rect.y = (rect.x + @vx).to_i, (rect.y + @vy).to_i
  end

  def paddle_bounce(paddle)
    @vy = -(@vy * @bounce)
    @vx = (rect.cx - paddle.rect.cx) * 0.25
  end
  
  def handle
  end
end

class PongGame < GameShell
  def initialize
    super([400, 300])
    @background = Surface.new(@screen.size)
    @computer   = Paddle.new(@screen.width, 5)
    @player     = Paddle.new(@screen.width, 5)
    @ball       = Ball.new

    @computer.rect.x = @screen.width / 2
    @player.rect.bottom = @screen.height

    make_magic_hooks( GameOver => lambda do |owner, ev|
                        puts ev.winner
                        @running = false
                      end)
    
    @player.make_magic_hooks( :left  => :move_left,
                              :right => :move_right,
                              KeyReleaseTrigger.new( :left )  => :stop_moving,
                              KeyReleaseTrigger.new( :right ) => :stop_moving )

    @sprites = Sprites::Group.new([@player, @computer, @ball])
    @sprites.extend Sprites::UpdateGroup
    @sprites.each {|s| register s }
  end

  protected

  def check_for_bounce
    if @ball.collide_sprite?(@player)
      @ball.paddle_bounce(@player)
    elsif @ball.collide_sprite?(@computer)
      @ball.paddle_bounce(@computer)
      @ball.rect.y = @computer.rect.height
    elsif @ball.rect.left < 0 || @ball.rect.right > @screen.width
      @ball.vx = -@ball.vx
    elsif @ball.rect.top < 0
      @queue << GameOver.new(:player)
    elsif @ball.rect.bottom > @screen.height
      @queue << GameOver.new(:computer)
    end
  end

  def ai_move
    if @ball.rect.cx < @computer.rect.cx
      @computer.move_left
    elsif @ball.rect.cx > @computer.rect.cx
      @computer.move_right
    else
      @computer.stop_moving
    end
  end

  def step
    check_for_bounce
    ai_move
    @sprites.undraw(@screen, @background)
    @sprites.update
    @sprites.draw(@screen)
    super
  end
end

PongGame.new.run if __FILE__ == $0
