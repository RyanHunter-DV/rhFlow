import re;

class Cmd: ##{
##}


class md(Cmd): ##{
	name = 'md';
##}

class lsel(Cmd): ##{
	name = 'lsel';
##}

def readline(line): ##{
	baseCmd = re.search("^\S+",line);
##}
