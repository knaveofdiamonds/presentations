require 'game_shell'
require 'sprites'

Paddle.send( :include, EventHandler::HasEventHandler )
Ball.send( :include, EventHandler::HasEventHandler )

include Rubygame
include Events
include EventTriggers
include EventActions

# Game Over event
GameOver = Struct.new(:winner)

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
