require 'rubygems'
require 'syntax'
require 'syntax/convertors/html'

convertor = Syntax::Convertors::HTML.for_syntax "ruby"

file = ARGV[0]

File.open(file.sub(/\.rb$/, '.html'), 'w') do |fh|
  fh.write convertor.convert( File.read(file) )
end
