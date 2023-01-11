#! /usr/bin/env ruby


def main ##{

	shell  = ARGV.shift;
	viewarg= ARGV.shift;
	termarg= ARGV.shift;
	envview = 'default';
	newterm = '1';
	envview = viewarg if viewarg!=nil and viewarg!='';
	newterm = termarg if termarg!=nil and termarg!='';

    cmds = [];
    if shell.upcase =='BASH'
	    cmds << "envview=#{envview}";
	    cmds << "newterm=#{newterm}";
    else
	    cmds << "set envview=#{envview}";
	    cmds << "set newterm=#{newterm}";
    end
	puts cmds.join(";");

	return 0;
end ##}


SIG = main();
exit SIG;
