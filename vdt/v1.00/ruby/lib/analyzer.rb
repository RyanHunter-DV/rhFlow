require 'syntax'
require 'md'

class VdtsAnalyzer; ##{



	public

	def initialize(c) ##{
		@config = c;
		@syn=VdtsSyntax.new(:default);
		##TODO
	end ##}

	def analyzeSrc ##{
		rawC = getSrcContents;
		willowedC = willowComments(rawC);
	end ##}


	private

	def getSrcContent ##{
		file = @config.srcFile
		fh = File.new(file,"r");
		contents = fh.readlines.map{&:chomp};
		fh.close
		return contents
	end ##}

	## willowComments method will willow all supported comments, both single line comment and
	## multi-line comment. for multi-line comment, which is start by /*, and end by */, these can
	## exists both in one line or multiple lines.
	## the return of this method is raw contents without any comment.
	def willowComments(rawC); ##{{{
		willowed = []
		rawC.each do ## {
			|line|
			## 1. detect comment (// or /*) of a line
			VdtsComment.line=(line);
			if VdtsComment.isMultiComment?
		end ## }
	end ##}}}





end ##}
