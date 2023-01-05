#! /usr/bin/env ruby


def main ##{

	shell  = ARGV.shift;
	envarg = ARGV.shift;
	envview = 'default';
	envview = envarg if envarg!=nil and envarg!='';

    cmds = ''
    if shell.upcase =='BASH'
	    cmds = "envview=#{envview}";
    else
	    cmds = "set envview=#{envview}";
    end
	puts cmds;

	return 0;
end ##}


SIG = main();
exit SIG;
