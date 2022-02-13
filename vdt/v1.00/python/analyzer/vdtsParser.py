import sys;
class VdtsParser: #{

	cmds = {};


	def __init__(self,cnts): #{
		self.loadCmds();
		self.parseContents(cnts);
	#}

	def loadCmds(self): #{
		self.cmds['md'] = __import__('md');
		self.cmds['vdts'] = __import__('vdts');
		## TODO
	#}

	def parseContents(self,cnts): #{
		## lnum: line number
		lnum = 1;
		for cnt in cnts:
			self.lineParser(cnt,lnum);
			lnum+=1;
	#}

	def lineParser(self,cnt,lnum): ##{{{
		## fw: first word
		fw = self.getStartWord(cnt)
		bc = self.baseCmd(fw);
		## dd: design definition, new name declared by vdts
		dd = self.searchDesignDefinition(fw);
		if (not bc) and (not dd):
			## report syntax error
			self.syntaxError('unsupported cmd: '+fw);

		if bc and dd:
			self.syntaxError('same cmd and design definition detected: '+fw);

		if bc:
			self.bcOperate(bc,cnt,lnum);

		if dd:
			self.ddOperate(dd,cnt,lnum);
	##}}}

	## operate baseCmd line, to the line and its operation
	def bcOperate(self,bc,line,lnum): ##{{{
		self.cmds[bc].parse(line,lnum);
	##}}}

	## operate designDefinition line, TODO
	def ddOperate(self,dd,line,lnum): ##{{{
	##}}}

	def syntaxError(self, msg): ##{{{
		## TODO, tmp call exit directly
		print ('[ERROR]',msg);
		sys.exit(3);
	##}}}

	## to get the first word from input command line, strip all the space chars
	##
	def getStartWord(self,line): ##{{{
	##}}}


	## this API to detect current line is a command line of supportive commands, such as: md/port
	## etc.
	def baseCmd(self,word): ##{{{
	##}}}

	## some of the cmd lines opearted on a new defined design scope, such as name defined by md, or
	## portGroup defined by port -g, this API will search all those possible command packets to
	## check if first word of this matches the design definition
	def searchDesignDefinition(self,word): ##{{{
	##}}}


#}
