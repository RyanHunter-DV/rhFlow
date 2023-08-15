class CompileFlow < StepBase

	#attr_accessor :simulator;

	attr :config;
	def initialize(opts={}) ##{{{
		super('compile',opts[:tconfig]);
		@config = targetDesignConfig(opts[:config]);
	end ##}}}

public

	def run ##{{{
		simulator = @config.simulator;
#TODO
		buildCompileCommand(simulator);
#TODO
		buildElabCommand(simulator) if simulator.hasElab?;
	end ##}}}

private

	# to build the simulator supported command file, the simulator will has it's own
	# options specified from user nodes file. and this tool will have inferred options
	def buildCompileCommand(simulator) ##{{{
		base = simulator.compile.command; # i.e. 'vcs', 'vlogan', 'xmvlog' ...
		simulator.compile.option(:filelist, @config.dirs[:fulllist]);
		#TODO, add more
#TODO, need options api in simulator.compile
		options = simulator.compile.options;
		cmd = base + options.join(' '); #TODO
	end ##}}}

	def targetDesignConfig(cname) ##{{{
		c = Rsim.find(:DesignConfig,cname);
#TODO, require an Exception.
		raise <Exception>.new("config(#{cname}) specified by user not elaborated") if c==nil;
		return c;
	end ##}}}
	
end
