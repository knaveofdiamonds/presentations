include Rubygame

class Paddle
  include Sprites::Sprite

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
end
