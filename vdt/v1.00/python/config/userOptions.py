from optparse import OptionParser;

class UserOptions: #{

	uo = None;

	def __init__(self): #{
		_uo = OptionParser();
		_uo.add_option('-s',dest='vdts',help='input vdts src file');
		(self.uo,args) = _uo.parse_args();
	#}

	def getVdts(self): #{
		return self.uo.vdts;
	#}


#}
