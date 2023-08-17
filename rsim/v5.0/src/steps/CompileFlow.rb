class CompileFlow < StepBase

	#attr_accessor :simulator;

	attr :config;
	def initialize(opts={}) ##{{{
		super('compile',opts[:tconfig],opts[:ui]);
		@config = targetDesignConfig(opts[:config]);
	end ##}}}

public

	def run ##{{{
		simulator = @config.simulator;
		files = {:compile=>'',:elab=>''};
#TODO
		files[:compile] = buildCompileCommand(simulator);
#TODO
		files[:elab] = buildElabCommand(simulator) if simulator.hasElab?;
		files.each_pair do |t,n|
			Rsim.mp.debug("#{t} command file built:(#{n})") if n!='';
			runSourceCommand(files[t]) if n!='';
		end
	end ##}}}

private

	# metho to run the command by 'cd #{path}; source #{file}'
	def runSourceCommand(path,file) ##{{{
		cmd = %Q|cd #{path};source #{file}|;
		status = @shell.exec(cmd);
		raise EdaException.new(status[0]) if status[1]!=0; #TODO, temporarily added.
	end ##}}}

	# to build the simulator supported command file, the simulator will has it's own
	# options specified from user nodes file. and this tool will have inferred options
	def buildCompileCommand(simulator) ##{{{
		base = simulator.compile.command; # i.e. 'vcs', 'vlogan', 'xmvlog' ...
		builtinOptions(simulator);
#TODO, need options api in simulator.compile
		options = simulator.compile.options;
		cmd = base + options.join(' '); #TODO
		file= File.join(@config.dirs[:out],%Q|#{simulator.name}Compile.cmd|);
		@shell.buildfile(file,[cmd]);
		return file;
	end ##}}}

	def builtinOptions(simulator) ##{{{
		simulator.compile.option(:filelist, @config.dirs[:fulllist]);
		#TODO, add more, may require to use @ui, @config
	end ##}}}

	def targetDesignConfig(cname) ##{{{
		c = Rsim.find(:DesignConfig,cname);
#TODO, require an Exception.
		raise <Exception>.new("config(#{cname}) specified by user not elaborated") if c==nil;
		return c;
	end ##}}}
	
end
