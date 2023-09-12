# This DL used for build flow, so it will then include all build related
# files, like design, component, config concepts etc.
"""
# Object description:
The flow to build targets, the specified config and all necessary components:
1. build root dirs necessary for certain config, components, such as:
	- $OUT/common, $OUT/config/<configname>, $OUT/components/<componentname>
2. 
"""

require 'exceptions/StepException'
class BuildFlow < StepBase

	attr :config; # object instance of DesignConfig, find from Rsim, specified by user.
	attr :configname;
	attr :commonDirs;

	def initialize(opts={}) ##{{{
		ui = opts[:ui];
		@configname='';
		@configname=opts[:config] if opts.has_key?(:config);
		super('build',opts[:tconfig],ui);
		setupCommonDirs(@tconfig);
	end ##}}}
public

	## API: run, this is a run api called by Core object to start running
	## the build flow, this api shall return Rsim::SUCCESS or Rsim::FAILED
	def run ##{{{
		# build required components into out
		setupConfig();
		messages = [:buildCommons,:buildComponents,:buildFilelist];
		messages.each do |message|
			return Rsim::FAILED if (self.send(message)==Rsim::FAILED);
		end
		return Rsim::SUCCESS;
	end ##}}}


private

	## API: setupDirs, to setup the dirname
	def setupCommonDirs(tconfig) ##{{{
		#raise StepException.new(@name,'stem option required but not specified') unless opts.has_key?(:stem);
		@commonDirs = {
			'out'       => tconfig.commonDirs[:out],
			'log'       => tconfig.commonDirs[:logs],
			'config'    => tconfig.commonDirs[:configs],
			'component' => tconfig.commonDirs[:components]
		}
	end ##}}}

	## API: setupConfigName(opts), to set the @config value, this is a must have field,
	# if user not provided, then will report fail.
	def setupConfig() ##{{{
		raise StepException.new(@name,'config required not specified') if @configname=='';
		@config = Rsim.find(:Config,@configname);
		raise StepException.new(@name,"config(#{@configname}) not found") unless @config;
	end ##}}}


	## API: buildComponents, according to required config which comes from UI, to build
	## components that required by that config.
	def buildComponents ##{{{
		# 1. build dirs, call comp.directory.build
		# 2. build generators, call comp.generator.build
		# 3. build filesets, call comp.generator.run
		@config.nestedComponents.each_pair do |iname,c|
			home = File.join(@commonDirs['component'],%Q|#{c.name}-#{iname}|);
			@shell.makedir(home);
# TODO, require build api in generator, the builder is current object
			Rsim.mp.debug("building component(#{c.vlnv}) by generator(#{c.generator.name})");
			c.generator.build(self,home);
# TODO, require run api in generator, the builder is current object
			c.generator.run(self,home);
		end
	end ##}}}
	## private API: buildFilelist, to generate the filelist for target simulator
	## this step called after elaborate, so the @config shall be ready now.
	def buildFilelist ##{{{
		incdirPrefix = @config.simulator.compile.option.format('incdir');
		incdirs=[];sources=[];
		# get nested components' filesets
		@config.nestedComponents.each do |c|
			incdirs.append(*c.filesets.incdir.map{|i| "#{incdirPrefix}#{i}"});
			sources.append(*c.filesets.source);
		end
		filelist = @config.dirs[:fulllist];
		@shell.buildfile(filelist,incdirs,sources);
#TODO, require outDir for config.
		lists = {
			:rtl => File.join(@config.dirs[:out],'rtl.filelist'),
			:tb => File.join(@config.dirs[:out],'tb.filelist')
		};
		lists.each_pair do |t,f|
			Rsim.mp.debug("Building filelist:(#{f})");
			genSpecifiedTypedFilelist(incdirPrefix,t,f);
		end
		genFullFilelist(lists.values());
	end ##}}}
	def genFullFilelist(lists) ##{{{
		# build a full list that includes all pre built lists
		#listname = File.join(@config.dirs[:out],'full.filelist');
		listname = @config.dirs[:fulllist];
		contents = lists.map{|i| %Q|-f #{i}|};
		@shell.buildfile(listname,contents);
	end ##}}}
	## this is a fixed flow for builder, to generate rtl filelist, no matter rtl list exists or not
	## if no rtl files specified, then an empty list will be built as well.
	def genSpecifiedTypedFilelist(prefix,t,listname) ##{{{
		incdirs=[];sources=[];
		@config.nestedComponents.each do |c|
			incdirs.append(*c.filesets.incdir[t].map{|i| "#{prefix}#{i}"});
			sources.append(*c.filesets.source[t]);
		end
		@shell.buildfile(listname,incdirs,sources);
	end ##}}}

	#TODO, to delete, ## API: elaborate, to elaborate all nodes pre-loaded, this will elaborate from
	#TODO, to delete, # component -> design -> config.
	#TODO, to delete, def elaborate ##{{{
	#TODO, to delete, 	Rsim.components.elaborate;
	#TODO, to delete, 	# one design only allowed in one project
	#TODO, to delete, 	Rsim.design.elaborate;
	#TODO, to delete, 	# one design can have multiple configs
	#TODO, to delete, 	Rsim.configs.elaborate;
	#TODO, to delete, 	@config = Rsim.find(Config,@configname)
	#TODO, to delete, end ##}}}

	## API: buildCommons, this local api to build commons such as the out dir,
	## out/common dir etc.
	def buildCommons ##{{{
		@commonDirs.each_value do |dir|
			Rsim.mp.debug("building common dir(#{dir})");
			@shell.makedir(dir);
		end
		#TODO
	end ##}}}

end
