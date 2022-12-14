#! /usr/bin/env ruby

require 'rhload';
rhload 'xmlprocessor.rh';

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

def main() ##{{{
	configf = ARGV[0];
	cmdtype = ARGV[1];
	## puts "config: #{configf}"
	return -1 if not File.exists?(configf);

	cdir = File.dirname(File.absolute_path(__FILE__));
	vars = {};
	xmlp = XmlProcessor.new();

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


SIG = main();
exit SIG;
