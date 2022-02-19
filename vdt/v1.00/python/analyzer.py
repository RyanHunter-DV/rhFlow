import vdtShell;
import cmds;
import proc;
class VdtsAnalyzer: ##{
	config;

	def __init__(self,config): ##{{{
		self.config = config;
	##}}}

	def analyzeContents(self,contents): ##{
		for line in contents: ##{
			if not cmds.decodeCmd(line): ##{
				print ("unrecognized command");
				return;
			##}
			else: ##{
				proc.processCmd(cmds.getDecodedCmd());
			##}
		##}
	##}

	def analyzeVdts(self): ##{{{
		contents = vdtShell.getFileContent(self.config.srcFileName());
		self.analyzeContents(contents);
	##}}}
##}
