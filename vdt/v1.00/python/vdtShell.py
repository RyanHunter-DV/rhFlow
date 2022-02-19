import os.path;

def chomp(x): ##{{{
	return x.strip("\n");
##}}}

def getFileContent(fileName): ##{{{
	if not os.path.isFile(fileName):
		return [];
	fileH = open(fileName,mode='r');
	return list(map(chomp,fileH.readlines()));
##}}}
