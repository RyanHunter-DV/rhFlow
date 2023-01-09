class Test
	attr_accessor :body;
	attr_accessor :context;
	attr_accessor :name;

	attr :config;

	def initialize n ##{{{
		@body={};
		@context=nil;
		@config =nil;
		@name = n.to_s;
	end ##}}}
	def addBody b ##{{{
		loc = b.source_location.join(',');
		@body[loc] = b;
	end ##}}}

	def evaluate ctxt ##{{{
		@context = ctxt;
		@body.each_pair do |loc,b|
			p =<<-CODE
				begin
					self.instance_eval &b;
				rescue TestEvalException => e
					e.process("test evaluate failed: #{loc}");
				end
			CODE
			self.instance_eval p;
		end
	end ##}}}


	#############################3
	## support commands
	#############################3
	def config n=nil ##{{{
		"""
		if called like: test.config, then return current @config
		if called like: config :testConfig, then to set current @config to the specified config object
		looking up through the config name
		"""
		return @config if n==nil;
		n = n.to_s;
		c = @context.findlocal(:config,n);
		raise TestEvalException.new("config(#{n}) not found in context(#{@context.name})") if c==nil;
		@config = c;
	end ##}}}
end

module TestPool
	@pool = {};
	def self.remove n ##{{{
		n = n.to_s;
		@pool.delete(n) if @pool.has_key?(n);
		return;
	end ##}}}
	def self.pool; return @pool; end

	def self.find n,create=false ##{{{
		if not @pool.has_key?(n)
			if create
				@pool[n] = Test.new(n);
			else
				return nil;
			end
		end
		return @pool[n];
	end ##}}}

end

def test n,&block ##{{{
	"""
	example to define a test:
	test :testname do
		simopt :xlm,''
		simopt :vcs, '' # TODO
		simopt :all,'+UVM_TESTNAME=xxxxx'
		config :configname
	end
	"""
	n = n.to_s;
	t = TestPool.find(n,true);
	t.addBody block;
	#TODO
end ##}}}
