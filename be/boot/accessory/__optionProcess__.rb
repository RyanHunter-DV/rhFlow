#! /usr/bin/env ruby


def main ##{
	arg = ARGV.shift;
	envview = 'default';
	envview = arg if arg!=nil and arg!='';

	cmds = "envview=#{envview}";
	puts cmds;

	return 0;
end ##}


SIG = main();
exit SIG;
