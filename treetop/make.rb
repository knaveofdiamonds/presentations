require 'rubygems'
require 'syntax'
require 'syntax/convertors/html'
require 'hpricot'

convertor = Syntax::Convertors::HTML.for_syntax "ruby"

File.open("text.withcode.markdown", "w") do |fh|
  File.readlines("text.markdown").each do |line|
    if line =~ /CODEFILE: (.+)/
      fh.write convertor.convert( File.read($~[1]) ).gsub("</pre>", "\n</pre>\n")
    else
      fh.write line
    end
  end
end

converted = `markdown text.withcode.markdown`.gsub("<h1>", "</div>\n\n<div class='slide'>\n<h1>")
File.unlink("text.withcode.markdown")
puts File.read("header.html")
puts converted
puts "</div></body></html>"
