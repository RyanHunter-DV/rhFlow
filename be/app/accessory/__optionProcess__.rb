#! /usr/bin/env ruby


def __processBashCommands__(raws) ##{{{
	shellcmds = [];

	cmd = raws[0];
	tool= raws[1];

	if cmd=='load' ##{
		## load
		shellcmds<<'cmd="load"';
		md = /(.+)\/(.+)/.match(tool);
		if md==nil
			shellcmds<<"tool=\"#{tool}\"";
			shellcmds<<'version="current"';
		else
			shellcmds<<"tool=\"#{md[1]}\"";
			shellcmds<<"version=\"#{md[2]}\"";
		end
	##}
	elsif cmd=='unload' ##{
		## unload
		shellcmds << 'cmd="unload"';
		shellcmds << "tool=\"#{tool}\"";
	##}
	else ##{
		puts "Error, not support command(#{cmd}) ";
		return '';
	end ##}
	return shellcmds;
end ##}}}

def __getShellType__ ##{
	if ENV.has_key?('SHELLTYPE')
		return ENV['SHELLTYPE'];
	else
		return nil;
	end
end ##}

def main() #{{{
	rawArgs=ARGV
	shell = __getShellType__;
	if shell==nil ##{
		puts "no SHELLTYPE set by environment";
		return -1;
	end ##}

	optionCommands='';
	if (shell.upcase=='BASH') ##{
		optionCommands = __processBashCommands__(rawArgs);
	end ##}

	return -1 if optionCommands=='';
	puts optionCommands;

	return 0;
end #}}}




sig = main();
exit(sig);
