require 'optparse';

class ProgramConfig; ##{

	attr :srcFile, :genFile;
	## @srcFile = nil;
	## @genFile = "default.v";

	genFile= "default.v";

	def initialize ##{{{
		OptionParser.new() do ##{
			|opt|
			opt.on('-s','--src=Src',"source vdts file name") do ##{
				|arg|
				@srcFile = arg;
			end ##}
			opt.on('-o','--out=Out',"gen file name") do ##{
				|arg|
				@genFile = arg;
			end ##}
		end.parse! ##}
	end ##}}}

	def parseUserOptions ##{
		puts "srcFile: #{@srcFile}";
		puts "genFile: #{@genFile}";
	end ##}


end ##}
