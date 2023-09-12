## doc: [[doc/v1/features/ipxact/Component.md]]
require 'ipxact/Filesets'
require 'generators/DefaultGenerator'
class Component < IpxactBase
	"""
	class for generating an IP-XACT component, which will be a collection
	of the meta-data.
	# Features
	- support commands:
		- generator, specify which tool to call to generate the specified files
		- fileset, collect files as the source file, this will be used by generator
		-
	"""
	
	attr :filesets;
	attr :toolchain; # the generator object
	attr :toolname; # the generator name

	# format
	# tooloption['name'] = 'value'
	#attr :tooloption; # for storing generator's options


	# indicates the component type.
	# :hdl
	# :tb
	# :others
	attr :type;

	# the target built config.
	#TODO, not used, attr :config;

	attr :paramovrds;

	attr :needs;

public
	def initialize(name,t) ##{{{
		super(name);
		@filesets = Filesets.new(t);
		@toolchain=nil;@type=t;
		# default generator is used while use nodes not specified a special generator.
		@toolname='DefaultGenerator';
		@paramovrds={};
		#@tooloption={};
		@needs=[];
		# a default toolchain is built when component created, if user has
		setupDefaultGenerator;
	end ##}}}

	## fileset command, to specify source files of this component, files can be specified
	## with wildcard format. Also multiple files can be specified with one fileset command
	## the opts is optional configs for fileset, for example, some of the files are part of
	## the source file, but shall not generated in filelist, then an option can be added like:
	## fileset :filelist=>false, "*.svh"
	def fileset(args,opts={}) ##{{{
		args = [args] if args.is_a?(String);
		nodeloc = currentNodeLocation(:full);
		path = currentNodeLocation(:path);
		Rsim.mp.debug("fileset(#{opts},#{args}) called by node(#{nodeloc})");
		# by default, the files added by fileset will be added into filelist
		opts[:filelist] = true unless opts.has_key?(:filelist);
		args.each do |fptrn|
			Rsim.mp.debug("calling addfiles(#{path},#{fptrn},#{opts})");
			@filesets.addfiles(path,fptrn,opts);
		end
	end ##}}}

	## generator, specify the generator tool to gen the source file to target, supports
	## - :default, use source dir and file directly, skip the generate step.
	## - :copy, copy all found source to target.
	## - :link, symbol link all source to target.
	## - :<custom>, custom tool specified by user.
	## the *args, users can specify specific args for custom tools.
	# if tool is :default, then will return the generator, else set @toolchain
	# when user call generator with empty args like: generate, which will return curretn defined generator,
	# if user not specified a component's generate, then it will use the :default type.
	def generator(name=nil) ##{{{
		# this will only be called by config to setup options,
		Rsim.mp.debug("generating called, with name(#{name})");
		return @toolchain if name==nil;

		# if name is not nil, which means called by generator('xxx')
		name = name.to_s;
		return if name=='default'; # return if user specified a default generator
		# if user specifies other toolchains, then need rebuild it.
		@toolname = %Q|#{name.to_s.capitalize}Generator|;
		buildGenerator(@toolname);
	end ##}}}

	# called by config to override a certain param, this will be stored in @paramovrds while, the component
	# is elaborated and params command is called to setup a new param, then it will check the @paramovrds hash.
	# using examples, from DesignConfig:
	# - design.compA.param :pa=>'xxx'
	def param(opts,parent=self) ##{{{
		if parent.is_a?(DesignConfig)
			opts.each_pair do |p,v|
				@paramovrds[p.to_sym] = v;
			end
		else
			# declaration
			declareParam opts;
		end
	end ##}}}


	## API: elaborate, to execute the blocks while stored by user nodes.
	# the given config is the object that the target config.
	def elaborate() ##{{{
		result = evalUserNodes(:component,self);
		Rsim.mp.debug("Component(#{@vlnv}) elaborate done");
		return result;
	end ##}}}

	## API: addCodeBlock(b), to add code block into this component, and record the block's location.
	def addCodeBlock(b) ##{{{
		push(b.source_location,b);
	end ##}}}

private

	def buildGenerator(name) ##{{{
		Rsim.mp.debug("build generator(#{name}) for component(#{@vlnv}), current generator(#{@toolchain.name})");
		require "generators/#{name}"
		newtool = eval %Q|#{name}.new(@toolchain)|;
		@toolchain = newtool;
	end ##}}}

	## declareParam, to declare parameters for this component, params can be overridden by a design configuration
	## params shall be declared with a format as a hash, like:
	## params :pa=>'10',:pb=>11 ...
	## those params will be finally defined as an instance variable in this component, and it can be used
	## to determine the behavior of component blocks.
#TODO, if multiple configs has multiple overrides, this base shall recognize it for build flow which will actually build
# only one config.
	def declareParam(plist) ##{{{
		Rsim.mp.debug("declarParam(#{plist})");
		plist.each_pair do |p,v|
			p=p.to_sym;valueUsed = v;
			valueUsed = @paramovrds[p] if @paramovrds.has_key?(p);
			self.instance_variable_set("@#{p}".to_sym,valueUsed);
		end
	end ##}}}


	## setupDefaultGenerator, a default toolchain is built hwne component created, and config can
	# set options firstly into this toolchain, if users update the toolchain to what they expected
	# the options will be copied to it as well.
	def setupDefaultGenerator; ##{{{
		@toolchain = DefaultGenerator.new();
		#puts "#{__FILE__}:(setupDefaultGenerator) is not ready yet."
	end ##}}}
end

## define a global command: component, which used by node files to declare a component
## with certain declaration blocks. Multiple component can be declared at different place
## t -> is the type of this component, will be used by user to specify different usages.
## t=:hdl, used to tell rsim current is an RTL component.
## t=:tb, used to tell rsim current is a testbench component.
def component(name,t=:others,&block) ##{{{
	isNew = false;
	c = Rsim.find(:Component,name);
	if c==nil
		c = Component.new(name,t);
		isNew=true;
	end
	c.addCodeBlock(block);
	Rsim.register(c) if isNew;
end ##}}}