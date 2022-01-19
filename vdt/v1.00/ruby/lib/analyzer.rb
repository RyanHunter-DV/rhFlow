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

	def willowComments(rawC); ## {
		willowed = []
		inMultiComment = false;
		rawC.each do ## {
			|line|
			if inMultiComment
				inMultiComment = (detectMultiCommentEndMark(line)==nil);
				next;
			end
			line = clearStartWhitespace(line);
			(cT,cP) = @syn.detectCommentTypeAndPos(line);
			case cT
			when 'SINGLE':
				line = removeComment(line,cP);
			when 'MULTI':
				## in case the end mark is in the same line
				eP = nil;
				eP = detectMultiCommentEndMark(line)
				inMultiComment = true if eP==nil;
				line = removeComment(line,cP,eP);
			else
				## no comment, do nothing
			end
			willowed.append(line);
		end ## }
	end ## }

	## if eP=nil, then remove from sP till to the end of line
	def removeComment(line,sP,eP=nil); ## {{{
	end ## }}}

	## return nil if no endMark, else return the start position
	def detectMultiCommentEndMark(line); ## {
	end ## }




end ##}
