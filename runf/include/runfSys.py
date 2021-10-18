from const import const;
import sys;


class exitProcessClass: ## {

	def errorNoFilelist(self): ## {
		print("[ERROR] filelist not specified, it's mandatory");
	## }

	def errorNoFileExists(self,file): ## {
		print("[ERROR] file not exists: "+file);
	## }


	def diePreProcess(self,dieSig,*ext): ## {
		if dieSig == const.errorFilelistNotSpecified: 
			self.errorNoFilelist();
		elif dieSig == const.errorFileNotExists:
			self.errorNoFileExists(ext[0]);
		else:
			print("unrecognized die signal: "+str(dieSig));
		## TODO, traceback here if necessary
	## }

	def __init__(self,sig,*ext): ## {
		if sig != const.normalExitSignal:
			self.diePreProcess(sig,*ext);
		else:
			print ("program exited successfully");
		## TODO
	## }

## }


def die(dieSig, *ext): ## {
	ep = exitProcessClass(dieSig,*ext);
	sys.exit(dieSig);
	pass;
## }

def exit(sig,*ext): ## {
	ep = exitProcessClass(sig,*ext);
	sys.exit(sig);
## }
