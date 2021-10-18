from optparse import OptionParser;
from const import const;
import runfSys; 
import os;

class runfConfig: ## {

	optParser = None;
	optHandle = None;
	remainedArgs = None;
	operations = [];

	def debug(self,msg): ## {
		print ("[DEBUG] "+msg);
	## }

	## operating on simTool ##{{{
	simTool = 'xrun';

	def useQuesta(self):
		self.simTool = 'questa';
	def useVCS(self):
		self.simTool = 'vcs';
	def useXrun(self):
		self.simTool = 'xrun';

	def getSimTool(self):
		return self.simTool;

	##}}}


	def __init__(self): ## {

		self.optParser = OptionParser();

		self.optParser.add_option(
			'-B','--build',
			action="store_true", dest="isBuild", default=False,
			help="specifying a command that to build the target for simulation"
		);
		self.optParser.add_option(
			'-E','--elab',
			action="store_true", dest="isElab", default=False,
			help="specifying a command that to elaborate the target simulation, for specific EDAs"
		);
		self.optParser.add_option(
			'-R','--run',
			action="store_true", dest="isRun", default=False,
			help="specifying a command that to run the target simulation"
		);
		self.optParser.add_option(
			'-A','--all',
			action="store_true", dest="isAll", default=False,
			help="specifying a command that from build to run for the target simulation"
		);
		self.optParser.add_option(
			'-v','--vcs',
			action="store_true", dest="useVCS", default=False,
			help="invoke VCS tool"
		);
		self.optParser.add_option(
			'-x','--xrun',
			action="store_true", dest="useXrun", default=False,
			help="invoke Xcelium tool"
		);
		self.optParser.add_option(
			'-q','--questa',
			action="store_true", dest="useQuesta", default=False,
			help="invoke questa tool"
		);
		self.optParser.add_option(
			'-f',
			action="append", dest="filelists", 
			help="specify (a) filelist(s) for this tool to run simulation"
		);
		self.optParser.add_option(
			'-b','--build_opt',
			action="append", dest="buildOptions",
			help="specify build options that will used by EDA tools in build operation"
		);
		self.optParser.add_option(
			'-w','--work_dir',
			action="store", dest='workDir',
			help="specify a work dir"
		);
		
	## }

	def selectSimTool(self,optUseVCS, optUseXrun, optUseQuesta): ## {
		if optUseQuesta:  self.useQuesta();
		if optUseVCS: self.useVCS();
		if optUseXrun: self.useXrun();
	## }

	def addAllOperations(self): ## {
		self.operations = ['build','elab','run'];
		return;
	## }

	## to generate operation list, will execute the sub commands from
	## list[0] ~ list[<end>]
	## for example, if has: [build,elab,sim], then this tool will execute
	## build->elab->sim
	def genOperation(self,optBuild,optElab,optRun,optAll): ## {
		if (optBuild or optAll):
			self.operations.append('build');

		if (optElab or optAll):
			self.operations.append('elab');

		if (optRun or optAll):
			self.operations.append('run');

		if (not len(self.operations)): self.addAllOperations();
	## }

	## if any of filelist specified by -f not exists, then report error and die
	def checkAllFilelistsExist(self): ## {
		for filelist in self.optHandle.filelists: ## {
			if not os.path.exists(filelist):
				runfSys.die(const.errorFileNotExists,filelist);
		## }
	## }

	def dieIfNoAvailableFilelist(self): ## {
		if not self.optHandle.filelists:
			runfSys.die(const.errorFilelistNotSpecified);
		if not len(self.optHandle.filelists):
			runfSys.die(const.errorFilelistNotSpecified);
		self.checkAllFilelistsExist();
	## }

	def dieIfNotSpecifiedWorkDir(self): ## {
		if not self.optHandle.workDir:
			runfSys.die(const.errorWorkDirNotSpecified);
	## }

	def parseArgsAndProcessToolConfigs(self): ## {
		localSig = const.normalExitSignal;
		(self.optHandle,self.remainedArgs) = self.optParser.parse_args();
		self.selectSimTool(
			self.optHandle.useVCS,
			self.optHandle.useXrun,
			self.optHandle.useQuesta
		);

		self.debug(" simTool: "+self.getSimTool()+" is chosen");

		self.genOperation(
			self.optHandle.isBuild,
			self.optHandle.isElab,
			self.optHandle.isRun,
			self.optHandle.isAll,
		);

		self.dieIfNoAvailableFilelist();
		self.dieIfNotSpecifiedWorkDir();


		## TODO

		return localSig;
	## }


	def hasHelp(self): ## {
		return self.optHandle.help;
	## }

	def needBuild(self): ## {
		if operations.count('build'):
			return True;
		return False;
	## }

	def needElab(self): ## {
		if operations.count('elab') and self.simTool == 'xrun':
			return True;
		return False;
	## }


## }
