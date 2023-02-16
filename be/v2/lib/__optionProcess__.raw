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
		shellcmds << 'version="current"';
	##}
	elsif cmd=='setup'
		# setup the app.Config
		shellcmds << 'cmd="setup"';
		md = /(.+)\/(.+)/.match(tool);
		if md==nil
			shellcmds<<"tool=\"#{tool}\"";
			shellcmds<<'version="current"';
			$stderr.puts "Error, version must specified when to setup an app.config";
		else
			shellcmds<<"tool=\"#{md[1]}\"";
			shellcmds<<"version=\"#{md[2]}\"";
		end
	else ##{
		$stderr.puts "Error, not support command(#{cmd}) ";
		shellcmds << 'cmd=""';
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
