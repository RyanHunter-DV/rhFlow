
class VdtsAnalyzer; ##{

	def initialize(c) ##{
		@config = c;
		##TODO
	end ##}


	def analyzeSrc ##{
		contents = getSrcContents;
	end ##}

	def getSrcContent ##{
		file = @config.srcFile
		fh = File.new(file,"r");
		contents = fh.readlines.map{&:chomp};
		fh.close
		return contents
	end ##}

end ##}
