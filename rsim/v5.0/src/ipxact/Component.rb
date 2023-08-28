## doc: [[doc/v1/features/ipxact/Component.md]]
require 'ipxact/Filesets'
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
	attr :tooloption; # for storing generator's options

	# A hash used to store dirs, available pairs:
	# [:published] -> the published dir of this component, out/components/<CompName>
	# [:source] -> the source node dir of this component, for different blocks, the source is different.
	# TODO, which will create unique id for different nodes for this component.
	attr :dirs;

	# indicates the component type.
	# :hdl
	# :tb
	# :others
	attr :type;

	# the target built config.
	#TODO, not used, attr :config;

	attr :paramovrds;

	attr_accessor :needs;

public
	def initialize(name,t) ##{{{
		super(name);
		@filesets = Filesets.new(t);
		@toolchain=nil;@type=t;
		# default generator is used while use nodes not specified a special generator.
		@toolname='DefaultGenerator';
		@tooloption={};@paramovrds={};
		@needs=[];
	end ##}}}

	## fileset command, to specify source files of this component, files can be specified
	## with wildcard format. Also multiple files can be specified with one fileset command
	## the opts is optional configs for fileset, for example, some of the files are part of
	## the source file, but shall not generated in filelist, then an option can be added like:
	## fileset :filelist=>false, "*.svh"
	def fileset(opts={},*args) ##{{{
		nodepath = currentNodeLocation(:path);
		$mp.debug("fileset(#{opts},#{args}) called by node(#{nodepath}/node.rh)");
		# by default, the files added by fileset will be added into filelist
		opts[:filelist] = true unless opts.has_key?(:filelist);
		args.each do |fptrn|
			@filesets.addfiles(nodepath,fptrn,opts);
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
	def generator(tool=nil,*args) ##{{{
		if tool==nil
			# this will only be called by config to setup options,
			return @tooloption;
		end
		@toolname = %Q|#{tool.to_s.capitalize}Generator|;
		buildGenerator;
	end ##}}}

	## params, to declare parameters for this component, params can be overridden by a design configuration
	## params shall be declared with a format as a hash, like:
	## params :pa=>'10',:pb=>11 ...
	## those params will be finally defined as an instance variable in this component, and it can be used
	## to determine the behavior of component blocks.
	def params(plist) ##{{{
		plist.each_pair do |p,v|
			p=p.to_sym;valueUsed = v;
			valueUsed = @paramovrds[p] if @paramovrds.has_key?(p);
			self.instance_variable_set("@#{p}".to_sym,valueUsed);
		end
	end ##}}}

	# called by config to override a certain param, this will be stored in @paramovrds while, the component
	# is elaborated and params command is called to setup a new param, then it will check the @paramovrds hash.
	# using exmaples, from DesignConfig:
	# - design.compA.param :pa=>'xxx'
	def param(opts={}) ##{{{
		opts.each_pair do |p,v|
			@paramovrds[p.to_sym] = v;
		end
	end ##}}}

	## API: need, this used by a component to indicate that if users want to embed this component,
	# it's dependent requirement will be embeded as well. In a design,
	# different component may need same requirements, so in design
	## level, will do unique operation to skip duplicate quoting of the same component.
	# the needed components shall be loaded by rhload before, or will report cannot find component issue.
	def need(comp) ##{{{
		# this is used only while building this component, the needed component shall be built as well.
		@needs << comp; #TODO, this part code may be changed while creating BuildFlow
	end ##}}}


	## API: elaborate, to execute the blocks while stored by user nodes.
	# the given config is the object that the target config.
	def elaborate(config) ##{{{
		#TODO, not used yet, @config = config;
		result = evalUserNodes(:component,self);
		return result;
	end ##}}}

	## API: addCodeBlock(b), to add code block into this component, and record the block's location.
	def addCodeBlock(b) ##{{{
		push(b.source_location,b);
	end ##}}}

private

	def buildGenerator ##{{{
		$mp.debug("build generator(#{@toolname}) for component(#{name})");
		require "generators/#{@toolname}"
		@toolchain = eval %Q|#{@toolname}.new()|;
#TODO, require setOptions api in generator, to setup a hash format option into it.
		@toolchain.setOptions(@tooloption);
	end ##}}}

end

## define a global command: component, which used by node files to declare a component
## with certain declaration blocks. Multiple component can be declared at different place
## t -> is the type of this component, will be used by user to specify different usages.
## t=:hdl, used to tell rsim current is an RTL component.
## t=:tb, used to tell rsim current is a testbench component.
def component(name,t=:others,&block) ##{{{
	isNew = false;
#TODO, require find in Rsim module, which actually call: @core.db.find ...
# to find if this type of the certain name model been created before.
	c = Rsim.find(:Component,name);
	if c==nil
		c = Component.new(name,t);
		isNew=true;
	end
	c.addCodeBlock(block);
#TODO, require register in Rsim module, which actually call: @core.db.register...
# to register a new component into db.
	Rsim.register(c) if isNew;
end ##}}}
