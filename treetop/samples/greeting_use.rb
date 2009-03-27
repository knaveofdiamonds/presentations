
output = GreetingParser.new.parse "Word up, world!"
puts "You said '#{output.greeting.text_value}' to: #{output.greeted.text_value}" if output

GreetingParser.new.parse("Farewell, forever") #=> returns nil
