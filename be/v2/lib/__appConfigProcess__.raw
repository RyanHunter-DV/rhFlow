#! /usr/bin/env ruby


def __getShellType__ ##{
	if ENV.has_key?('SHELLTYPE')
		return ENV['SHELLTYPE'];
	else
		return nil;
	end
end ##}
def __processBashCommands__ vars,cmdtype ##{{{
	cmds = [];
	vars.each_pair do |var,val|
		if cmdtype=='load'
			l = "export #{var}=#{val}"
		else
			if var=='PATH'
				op = ENV['PATH'];
				## puts "op: #{op}";
				ov = val.sub(/:\$PATH/,'');
				## puts "ov: #{ov}";
				l = "export PATH=#{op.sub(ov,'')}";
			else
				l = "unset #{var}"
			end
		end
		cmds << l;
	end
	return cmds.join(';');
end ##}}}

def __processline__(line,xmlp) ##{{{
	pair = line.split('=');
	xmlp.setenv(pair[0],pair[1]);
	return;
end ##}}}
def setupconfig(f,xmlp) ##{{{
	$stderr.puts "Entering your variable=value pairs, finished with cmd: exit";
	$stderr.puts "format example: PATH=/home/ryan";
	$stderr.print ">> ";
	line = STDIN.readline().chomp;
	while (line != 'exit')
		__processline__(line,xmlp);
		$stderr.print ">> ";
		line = STDIN.readline().chomp;
	end
	xmlp.flush(f); ## flush to write app.config file
	
end ##}}}
def main() ##{{{
	configf = ARGV[0];
	cmdtype = ARGV[1];
	## puts "config: #{configf}"
	return -1 if not File.exists?(configf);

	cdir = File.dirname(File.absolute_path(__FILE__));
	vars = {};
	xmlp = XmlProcessor.new();

	if cmdtype=='setup'
		setupconfig(configf,xmlp);
		return 0;
	end

	xmlp.loadSource(configf);
	while (xmlp.has('env-var')) do
		vars[xmlp.pop('env-var')] = xmlp.pop('env-val');
		## puts "vars: #{vars}"
	end

	shell = __getShellType__;
	shellCommands='';
	if (shell.upcase=='BASH') ##{
		shellCommands = __processBashCommands__(vars,cmdtype);
	end ##}

	puts shellCommands;
	return 0;
end ##}}}

$toolHome = File.dirname(File.absolute_path(__FILE__));
$LOAD_PATH << $toolHome;
require 'xmlprocessor.rb';
SIG = main();
exit SIG;
