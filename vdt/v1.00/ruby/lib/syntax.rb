## a class for comment syntax
class VdtsComment; ##{{{

	@@multiCommentStartPtrn = /\/\*/;
	@@multiCommentEndPtrn = /\*\//;
	@@singleCommentPtrn = /\/\//;
	@@line = "";
	@@multiCommentStart = false;
	@@multiCommentEnd = false;

	public

	## judge if the input source line is multi line comment?
	## if is, return true, else return false
	## attention a the multi start/end comment pattern exists in one line will be
	## treated as singleComment
	def self.isMultiComment? ##{{{
		self.multiCommentStart;
		self.multiCommentEnd;
		return false if (@@multiCommentStart&&@@multiCommentEnd);
		return true if (@@multiCommentStart||@@multiCommentEnd);
	end ##}}}

	def self.isSingleComment? ##{{{
		return true if (self.singleCommentStart);
		return false;
	end ##}}}

	## API to willow out the comments, and return other contents of this line
	def self.willowed ##{{{
		pos = self.singleCommentStart;
		return @@line[0..(pos-1)] if pos&&pos>0;
		if (@@multiCommentStart&&@@multiCommentEnd)
			sPos = self.multiCommentStart;
			ePos = self.multiCommentEnd;
			eos = @@line.length;
			return @@line[0..(sPos-1)]+@@line[(ePos+2)..(eos-1)];
		elsif (@@multiCommentStart)
			pos = self.multiCommentStart;
			return @@line[0..(pos-1)] if pos>0;
		elsif (@@multiCommentEnd)
			pos = self.multiCommentEnd;
			eos = @@line.length;
			return @@line[(pos+2)..(eos-1)];
		end
		## here means no comment detected
		return @@line;
	end ##}}}

	## to clear the multiCommentStart/End flags to false
	def self.clearMultiCommentFlags ##{{{
		@@multiCommentStart = false;
		@@multiCommentEnd = false;
	end ##}}}

	## to set a string to line
	def self.line= (s) ##{{{
		@@line = s;
		self.clearMultiCommentFlags;
	end ##}}}


	private
	
	## detect the multiComment flag of current line, return the position,
	## if return value is nil, which means not matched
	def self.multiCommentStart ##{{{
		pos = @@line=~@@multiCommentStartPtrn;
		if pos != nil;
			@@multiCommentStart=true;
		end
		return pos;
	end ##}}}

	## to detect the multiComment end flag
	def self.multiCommentEnd ##{{{
		pos = @@line=~@@multiCommentEndPtrn;
		if pos != nil;
			@@multiCommentEnd=true;
		end
		return pos;
	end ##}}}

	## return position if found single comment, else return nil
	def self.singleCommentStart ##{{{
		pos = @@line=~@@singleCommentPtrn;
		return pos;
	end ##}}}

end ##}}}
