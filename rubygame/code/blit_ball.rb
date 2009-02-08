require 'game_shell'

@game = GameShell.new( [400,300] )

ball = Surface.new( [9,9] )
ball.draw_circle_a( [4,4],4,[0xff]*3 )
ball.draw_circle_s( [4,4],4,[0xff]*3 )

ball.blit( @game.screen, [10,10] )

@game.run

