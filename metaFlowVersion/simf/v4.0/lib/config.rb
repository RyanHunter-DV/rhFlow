class Config

	attr_accessor :name;
	attr_accessor :body;
	attr_accessor :comps;
	attr_accessor :context;
	attr_accessor :debug;
	## simulator flag, supports: 
	## :xlm -> xcelium
	## :vcs -> vcs
	attr_accessor :simulator;
	attr_accessor :filelist;
	attr_accessor :precompopts; ## opts that before filelist
	attr_accessor :compopts; ## normal opts, will after filelist
	attr_accessor :elabopts; ## normal opts, will after filelist
	attr_accessor :worktop;

	def __initfields__ ##{{{
		@name = '';
		@body = {};
		@comps= {};
		@precompopts={};
		@compopts={};
		@elabopts={};
		@context=nil;
		@debug=nil;
		@simulator= :xlm; ## default
		@filelist = nil;
		@worktop  = '';
	end ##}}}
	def initialize n,d ##{{{
		__initfields__;
		@name = n;
		@debug= d;
	end ##}}}
	def addBody b ##{{{
		loc = b.source_location.join(',');
		@body[loc] = b;
	end ##}}}
	def evaluate ctxt ##{{{
		"""
		evalute all blocks in the config's body, support commands:
		required: TBD
		compopt: TBD
		elabopt: TBD
		simopt:  TBD
		"""
		@context = ctxt;
		@body.each_pair do |loc,b|
			p =<<-CODE
				begin
					self.instance_eval &b;
				rescue ConfigEvalException => e
					e.process("config evaluate failed: #{loc}");
				end
			CODE
			self.instance_eval p;
		end
	end ##}}}
	def finalize ##{{{
		# TODO, currently do nothing for config's finalize
	end ##}}}

	#####################################
	###### supported config commands
	#####################################
	def component n,**opts ##{{{
		"""
		if component instantiated within a config, then the component should be evaluted
		before doing next command
		"""
		n = n.to_s;
		@debug.print("instantiate component(#{n}), in context(#{@context.name})");
		c = @context.findlocal(:component,n);
		raise ConfigEvalException.new(", cannot find component(#{n})") if c==nil;
		c.evaluate;
		instname = c.name;
		instname = opts[:as] if opts.has_key?(:as);
		@comps[instname.to_s] = c;
		return;
	end ##}}}

	def compopt eda,*opts,**args ##{{{
		eda = eda.to_sym;
		compopts = @compopts;
		compopts = @precompopts if args.has_key?(:pre);
		compopts[eda]=[] unless compopts.has_key?(eda);
		compopts[eda].append(*opts);
		return;
	end ##}}}
	def elabopt eda,*opt,**args ##{{{
		eda = eda.to_sym;
		@elabopts[eda]=[] unless @elabopts.has_key?(eda);
		@elabopts[eda].append(*opts);
		return;
	end ##}}}
	def worktop n=nil ##{{{
		"""
		if n==nil or '', then return @worktop, else set @worktop
		"""
		return @worktop unless n;
		@worktop = n.to_s;
	end ##}}}

end

module ConfigPool
	@pool = {};
	@debug= nil;

	def self.debug= d; @debug=d; end
	def self.debug; return @debug; end
	def self.pool; return @pool; end
	def self.remove n ##{{{
		n = n.to_s;
		@pool.delete(n) if @pool.has_key?(n);
		return;
	end ##}}}
	def self.find n,create=false ##{{{
		n = n.to_s;
		if not @pool.has_key?(n)
			if create==true
				@pool[n] = Config.new(n,@debug);
			else
				return nil;
			end
		end
		return @pool[n];
	end ##}}}
end

def config n,tool=nil,&block ##{{{
	"""
	example of a config:
	config :configname do
		required :componentA ?
		required :componentB
		compopt :xlm, ''
		compopt :vcs, ''
		compopt :all, ''
		elabopt :all, '' # available for xcelium only
		simopt  :all, ''
	end
	"""
	c = ConfigPool.find(n,true);
	c.simulator= tool.to_sym if tool;
	c.addBody(block);
end ##}}}
