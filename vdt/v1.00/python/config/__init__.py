import sys;
import os;

## add current libPath into python lib search path
libPath = os.path.dirname(os.path.abspath(__file__));
sys.path.append(libPath);


_options = None;
## to instantiate the userOption object and process input user options
def processUserOptions(): #{
	global _options;
	## TODO
#}

