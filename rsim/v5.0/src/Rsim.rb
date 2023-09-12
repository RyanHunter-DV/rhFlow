require 'libs/cmdshell';
require 'libs/MessagePrinter';
require 'exceptions/RsimException';
require 'UserInterface';
require 'ipxact/DataPool';
require 'Core';

module Rsim

	FAILED = 1;
	SUCCESS= 0;

	@mp   =nil;
	@steps=nil;

	@components=nil; # object of ComponentPool
	@design=nil;
	@configs=nil; # object of ConfigPool
	@tconfig=nil;@ui=nil;

	#TODO, not used yet, ## self.tconfig, return the tool config
	#TODO, not used yet, def self.tconfig; ##{{{
	#TODO, not used yet, 	return @tconfig;
	#TODO, not used yet, end ##}}}

	## self.dirs, return the dirs stored in tool config
	def self.dirs; ##{{{
		return @tconfig.commonDirs;
	end ##}}}

	"""
	self.design, return the instance var @design
	"""
	def self.design ##{{{
		return @design;
	end ##}}}

	def self.mp() ##{{{
		return @mp;
	end ##}}}
	def self.steps() ##{{{
		return @steps;
	end ##}}}
	def self.init () ##{{{
		@mp = MessagePrinter.new('Rsim',:debug);
		self.mp.debug("message printer completed for debug mode");
		@steps=[];
		@components= DataPool.new(:component);
		@configs   = DataPool.new(:config);
	end ##}}}
	## start the core of Rsim tool, to process major steps.
	def self.start () ##{{{
		self.init();
		begin
			@ui = UserInterface.new();
			@tconfig = ToolConfig.new(@ui);
			core = Core.new(@ui,@tconfig);
		rescue RsimException => e
			e.process();
			self.mp.debug("get exitstatus: #{e.exitstatus}");
			return e.exitstatus if (e.exit?);
#TODO, may be extra process here.
		end
		return 0;
	end ##}}}
	
	## API: self.find(type,name), to find a certain typed object is defined
	# or not, according to type, search within certain type, and search by
	# the name.
	def self.find(t,name) ##{{{
		self.mp.debug("finding #{name} in #{t}");
		case(t)
		when :Component
			return @components.find(name);
		when :Config
			return @configs.find(name);
		when :Design
			return @design;
		else
#TODO, require exception object, raise NodeLoadException.new("find(#{t},
			# #{name})","invalid
			# type");
		end
	end ##}}}

	## API: self.register(o), register current object into certain place according to different
	# type
	def self.register(o) ##{{{
		@components.register(o) if o.is_a?(Component);
		@configs.register(o) if o.is_a?(DesignConfig);
		if o.is_a?(Design)
			if @design!=nil
				raise UserException.new("design already registered and only can have one for each project");
			else
				@design = o;
			end
		end
	end ##}}}


	## self.elaborate, to elaborate the loaded meta data
	def self.elaborate; ##{{{
		Rsim.mp.info("starting elaborating the user nodes");
		raise UserException.new("No design node specified by user") if @design==nil;
		@design.elaborate;
		@configs.elaborate;
		@components.elaborate;
		#puts "#{__FILE__}:(self.elaborate) is not ready yet."
	end ##}}}

end
