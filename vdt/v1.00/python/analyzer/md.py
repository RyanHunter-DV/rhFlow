

class ClassMd(object): ##{{{
	staticInst = None;
	mdStr = 'md';

	def __new__(cls,*args,**kws): #{
		if cls.staticInst == None:
			cls.staticInst = object.__new__(cls,*args,**kws);
		return cls.staticInst;
	#}

	def parseFullCmdLine(self,line,lnum): ##{{{
	##}}}

##}}}


_md = None;


def parse(line,lnum): #{
	global _md;
	if _md == None: _md = ClassMd();
	_md.parseFullCmdLine(line,lnum);
#}
