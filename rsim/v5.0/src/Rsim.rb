require 'libs/cmdshell';
require 'MessagePrinter';
require 'RsimExceptions';
require 'UserInterface';
require 'Core';
require 'ComponentPool';
require 'ConfigPool';

module Rsim

	FAILED = 1;
	SUCCESS= 0;

	@mp   =nil;
	@steps=nil;

	@components=nil; # TODO, object of ComponentPool
	@design=nil;
	@configs=nil; # TODO, object of ConfigPool

	def self.mp() ##{{{
		return @mp;
	end ##}}}
	def self.steps() ##{{{
		return @steps;
	end ##}}}
	def self.init () ##{{{
		@mp = MessagePrinter.new('Rsim',:debug);
		@steps=[];
		@components = ComponentPool.new();
		@configs = ConfigPool.new();
	end ##}}}
	## start the core of Rsim tool, to process major steps.
	def self.start () ##{{{
		self.init();
		begin
			ui = UserInterface.new();
			core = Core.new(ui);
		rescue RsimException => e
			e.process();
			return e.exitstatus if (e.exit?);
			#TODO, may be extra process here.
		end
		return 0;
	end ##}}}
	
	## API: self.find(type,name), to find a certain typed object is defined
	# or not, according to type, search within sertain type, and search by
	# the name.
	def self.find(t,name) ##{{{
		@mp.debug("finding #{name} in #{t}");
		case(t)
		when :Component
			return @components.find(name);
		when :Config
			return @configs.find(name);
		when :Design
			return @design;
		else
			raise NodeLoadException.new("find(#{t},#{name})","invalid type");
		end
	end ##}}}

	## API: self.register(o), register current object into certain place according to different
	# type
	def self.register(o) ##{{{
		@components.register(o) if o.is_a?(Component);
		@configs.register(o) if o.is_a?(DesignConfig);
		if o.is_a?(Design)
			if @design!=nil then
				raise NodeLoadException.new("register","design already registered");
			else
				@design = o;
			end
		end
	end ##}}}
end
