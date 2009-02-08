surface = Surface.load( "an_image_file.bmp" )

ball = Surface.new( [9,9] )
ball.draw_circle_a( [4,4],4,[0xff]*3 )
ball.draw_circle_s( [4,4],4,[0xff]*3 )

ball.blit( screen, [10,10] )
