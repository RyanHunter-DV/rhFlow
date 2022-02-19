from optparse import OptionParser;

class ProgramConfigs: ##{

	optParse;
	otherArgs;

	def __init__(self): ##{{{
		parser = OptionParser();
		parser.add_option('-f',dest="srcFileName");
		parser.add_option('-o',dest="genFileName");
		(self.optParse,self.otherArgs) = parser.parse_args();
	##}}}

	def userOptionParse(self): ##{{{
		if not self.optParse.genFileName :
			self.optParse.genFileName = "default.v";
	##}}}

	def genFileName(self): ##{{{
		return self.optParse.genFileName;
	##}}}

	def srcFilename(self): ##{{{
		return self.optParse.srcFileName;
	##}}}

##}
