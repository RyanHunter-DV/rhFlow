#! /usr/bin/env ruby
#
line = "class #() /**/// this is the /**/comment line";
defaultCommentPattern = /\/[\/|\*]/;
puts defaultCommentPattern.match(line);
index = 0;
line.each_char do ## {
	|c|
	puts "#{index}" if c=='/';
	index+=1;
end ## }
