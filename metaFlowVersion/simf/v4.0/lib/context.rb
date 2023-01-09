"""
This is the context lib, declared a global API: context, and a class to process context features
"""


class Context

    @@instances = {};
	@@debug     = nil;
	@@current   = nil;
    attr_accessor :name;
	## one context only has one definition body
	attr_accessor :body;

	attr_accessor :comps;
	attr_accessor :confs;
	attr_accessor :tests;
	attr_accessor :parsed;

	def self.debug; return @@debug; end
	def self.debug= d;@@debug=d; end
	def __initfields__ ##{{{
		@name  = '';
		@body  = nil;
		@parsed= false;

		@comps={};@confs={};@tests={};
	end ##}}}
    def initialize n,b ##{{{
		__initfields__;
        @name = n.to_s;
		@body = b;
    end ##}}}

    def self.instance= rhs ##{{{
        @@instances[rhs.name] = rhs;
		@@current = rhs;
    end ##}}}
	def self.current;return @@current;end

    def self.get n ##{{{
        n = n.to_s;
        return @@instances[n] if (@@instances.has_key?(n));
        return nil;
    end ##}}}
    def loadPlugin f ##{{{
        """
        plugin class been loaded into the Context object
        """
        rhload f;
    end ##}}}
    def configPlugin block ##{{{
        self.instance_eval &block;
    end ##}}}


	def finalize ##{{{
		"""
		context is more like a namespace of a project, so all tests/configs/components within that
		context should be remapped
		"""
		@confs.each_pair do |n,o|
			o.evaluate(self);
			o.finalize();
		end
		@tests.each_pair do |n,o|
			o.evaluate(self);
			#TODO, o.finalize();
		end
	end ##}}}

	def evaluate ##{{{
		begin
			p =<<-CODE
				begin
					self.instance_eval &@body;
				rescue EvalException => e
					e.process("block: #{@body.source_location.join(',')}");
				end
				return 0;
			CODE
			sig = self.instance_eval p;
			raise EvalException if sig!=0;
		rescue EvalException => e
			e.process("context: #{@name},location: #{@body.source_location}");
		end
	end ##}}}
	def self.parse ##{{{
		"""
		a static method to parse all contexts here, if context is parsed already, then skip it
		"""
		@@instances.each_value do |ctxt|
			next if ctxt.parsed;
			ctxt.evaluate; ## evaluate body defined in context
			debug.print("#{ctxt.name} evaluating done, comps: #{ctxt.comps}");
			ctxt.parsed = true;
		end
	end ##}}}

	def findlocal t,n ##{{{
		"""
		find a component/config/test locally, no need for the context name,
		can find by: 'compA'
		"""
		fn = "#{@name}.#{n}";
		t = t.to_sym;
		pool = {};
		if t==:config
			pool = @confs;
		elsif t==:component
			pool = @comps;
		else
			pool= @tests;
		end
		return nil if not pool.has_key?(fn);
		return pool[fn];
	end ##}}}
	
	def self.find t,n ##{{{
		"""
		called by the static Context class, to find a full named component/config/test etc.
		"""
		na = n.to_s.split('.');
		return nil if na.length()<=1; ## if the n has no context name, then return nil directly.
		return nil if not @@instances.has_key?(na[0]);
		@@instances[na[0]].findlocal(t,na[1]);
	end ##}}}

	#############################################
	## body commands supported by context
	#############################################

	def component n,**opts ##{{{
		##TODO, :as not support for now.
		n = n.to_s;
		c = ComponentPool.find(n);
		raise EvalException.new(", no component defined as #{n}") if c==nil;
		@comps["#{@name}.#{c.name}"] = c;
		ComponentPool.remove(n);
	end ##}}}
	def config n,**opts ##{{{
		n = n.to_s;
		c = ConfigPool.find(n);
		raise EvalException.new(", no config defined as #{n}") if c==nil;
		@confs["#{@name}.#{c.name}"] = c;
		ConfigPool.remove(n);
	end ##}}}
	def test n,**opts ##{{{
		n=n.to_s;
		t = TestPool.find(n);
		raise EvalException.new(", no test/testgroup defined as #{n}") if t==nil;
		@tests["#{@name}.#{t.name}"] = t;
		TestPool.remove(n);
	end ##}}}
end

def context n,&block ##{{{
    Context::instance= Context.new(n,block);
end ##}}}
