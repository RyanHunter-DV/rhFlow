import sys;
import os;

## add current libPath into python lib search path
libPath = os.path.dirname(os.path.abspath(__file__));
sys.path.append(libPath);


import config; ## config of vdt

import comment;
import fileUtils as fu;

from constant import *;
from vdtsParser import *;

vdtsP = None;

## this API can directly process *.vdts files and 
## translated to a database into the db files.
def processVdts(filename): #{
	rCnts = fu.getContents(filename);
	siftedCnts = comment.sift(rCnts,'//');
	global vdtsP;
	vdtsP = VdtsParser(siftedCnts);
	## TODO
#}


