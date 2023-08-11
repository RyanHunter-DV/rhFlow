# This DL used for build flow, so it will then include all build related
# files, like design, component, config concepts etc.

class Build < StepBase

	# the detailed string information of latest failure
	attr_accessor :shell;

	attr :configname;
	attr :config;
	attr :commonDirs;

	def initialize(opts={}) ##{{{
		super('build');
		@shell= CmdShell;
		setupConfigName(opts);
		setupDirs(opts);
		@config = nil;
		#TODO
	end ##}}}
public

	## API: run, this is a run api called by Core object to start running
	## the build flow, this api shall return Rsim::SUCCESS or Rsim::FAILED
	## #TODO
	def run ##{{{
		## TODO, to delete, raise BuildException.new('buildCommons',@reason) if (buildCommons==Rsim::FAILED);
		## TODO, to delete, raise BuildException.new('elaborate',@reason) if (elaborate==Rsim::FAILED);
		# build required components into out
		messages = [:elaborate,:buildCommons,:buildComponents,:buildFilelist];
		messages.each do |message|
			return Rsim::FAILED if (self.send(message)==Rsim::FAILED);
		end
		return Rsim::SUCCESS;
	end ##}}}


private

	## API: setupDirs, to setup the dirname
	def setupDirs(opts) ##{{{
		raise StepException.new(@name,'stem option required but not specified') unless opts.has_key?(:stem);
		stem = opts[:stem];
		out  = "#{stem}/out";
		@commonDirs = {
			'out'       => out,
			'log'       => "#{out}/logs",
			'config'    => "#{out}/configs",
			'component' => "#{out}/components"
		}
	end ##}}}

	## API: setupConfigName(opts), to set the @config value, this is a must have field,
	# if user not provided, then will report fail.
	def setupConfigName(opts) ##{{{
		@configname = '';
		raise StepException.new(@name,'config required not specified') unless opts.has_key?(:config);
		@configname = opts[:config];
	end ##}}}

	## API: buildFilelist, to generate the filelist for target simulator
	## this step called after elaborate, so the config shall be ready now.
	def buildFilelist ##{{{
		config = Rsim.find(Config,@configname)
		incdirPrefix = config.simulator.filelist.option('incdir')
		incdirs=[];sources=[];
		# get nested components' filesets
		config.nestedComponents.each do |c|
			incdirs.append(*c.filesets.incdir.map{|i| "#{incdirPrefix}#{i}"});
			sources.append(*c.filesets.source);
		end
		@shell.buildfile(filelist,incdirs,sources);
	end ##}}}

	## API: buildComponents, according to required config which comes from UI, to build
	## components that required by that config.
	def buildComponents ##{{{
		# 1. build dirs, call comp.directory.build
		# 2. build generators, call comp.generator.build
		# 3. build filesets, call comp.generator.run
		@config.nestedComponents.each do |c| #TODO, require api in DesignConfig
			@shell.makedir(c.dirs[:published]); #TODO, require directory in component, indicates the out/components/<compname> dir.
			c.generator.build(self); # TODO, require build api in generator, the builder is current object
			c.generator.run(self); # TODO, require run api in generator, the builder is current object
			#buildToolChainCmd(c);
			#buildcomponent(c);
		end
	end ##}}}

	## API: elaborate, to elaborate all nodes pre-loaded, this will elaborate from
	# component -> design -> config.
	def elaborate ##{{{
		Rsim.components.elaborate;
		# one design only allowed in one project
		Rsim.design.elaborate;
		# one design can have multiple configs
		Rsim.configs.elaborate;
		@config = Rsim.getConfigObjectByname(@configname);
	end ##}}}

	## API: buildCommons, this local api to build commons such as the out dir,
	## out/common dir etc.
	def buildCommons ##{{{
		@commonDirs.each_value do |dir|
			Rsim.mp.debug("building common dir(#{dir})");
			@shell.makedir(dir);
		end
		#TODO
	end ##}}}

	#def buildToolChainCmd(comp) ##{{{
	#	#TODO, to build given component object's toolchain command, by calling which can
	#	# build it from source to target.
	#end ##}}}
end
