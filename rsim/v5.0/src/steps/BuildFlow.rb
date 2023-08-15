# This DL used for build flow, so it will then include all build related
# files, like design, component, config concepts etc.

class BuildFlow < StepBase


	attr :configname;
	attr :config; # object instance of DesignConfig, find from Rsim, specified by user.
	attr :commonDirs;

	def initialize(opts={}) ##{{{
		super('build',opts[:tconfig]);
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
		#raise StepException.new(@name,'stem option required but not specified') unless opts.has_key?(:stem);
		#TODO, to be deleted, stem = opts[:stem];
		#TODO, to be deleted, out  = "#{stem}/out";
		@commonDirs = {
#TODO, require commonDirs in ToolConfig.
			'out'       => tconfig.commonDirs[:out],
			'log'       => tconfig.commonDirs[:logs],
			'config'    => tconfig.commonDirs[:configs],
			'component' => tconfig.commonDirs[:components]
		}
	end ##}}}

	## API: setupConfigName(opts), to set the @config value, this is a must have field,
	# if user not provided, then will report fail.
	def setupConfigName(opts) ##{{{
		@configname = '';
		raise StepException.new(@name,'config required not specified') unless opts.has_key?(:config);
		@configname = opts[:config];
	end ##}}}


	## API: buildComponents, according to required config which comes from UI, to build
	## components that required by that config.
	def buildComponents ##{{{
		# 1. build dirs, call comp.directory.build
		# 2. build generators, call comp.generator.build
		# 3. build filesets, call comp.generator.run
		@config.nestedComponents.each do |c|
#TODO, require directory in component, indicates the out/components/<compname> dir.
			@shell.makedir(c.dirs[:published]);
# TODO, require build api in generator, the builder is current object
			c.generator.build(self);
# TODO, require run api in generator, the builder is current object
			c.generator.run(self);
		end
	end ##}}}
	## private API: buildFilelist, to generate the filelist for target simulator
	## this step called after elaborate, so the @config shall be ready now.
	def buildFilelist ##{{{
		# TODO, filelist.option, api to return a speficied filelist option for 'incdir', shall be added in filelist object's api.
		incdirPrefix = @config.simulator.filelist.option('incdir');
		incdirs=[];sources=[];
		# get nested components' filesets
		@config.nestedComponents.each do |c|
			incdirs.append(*c.filesets.incdir.map{|i| "#{incdirPrefix}#{i}"});
			sources.append(*c.filesets.source);
		end
		filelist = generateFilelistName(@config);
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
		listname = File.join(@config.dirs[:out],'full.filelist');
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

	## API: elaborate, to elaborate all nodes pre-loaded, this will elaborate from
	# component -> design -> config.
	def elaborate ##{{{
		Rsim.components.elaborate;
		# one design only allowed in one project
		Rsim.design.elaborate;
		# one design can have multiple configs
		Rsim.configs.elaborate;
		@config = Rsim.find(Config,@configname)
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

end
