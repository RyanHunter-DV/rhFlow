class Component ##{{{

	attr_accessor :body;
	attr_accessor :name;
	attr_accessor :requires;
	attr_accessor :compopts;
	attr_accessor :precompopts;
	attr_accessor :elabopts;
	attr_accessor :simopts;
	attr_accessor :filesets;
	attr_accessor :outpath;

	def initialize n ##{{{
		@name    =n;
		@body    ={};
		@requires=[];
		@compopts={};
		@precompopts={};
		@elabopts={};
		@simopts ={};
		@filesets=[];
		@outpath ='';
	end ##}}}
	
	def addBody b ##{{{
		loc = b.source_location.join(',');
		@body[loc] = b;
	end ##}}}

	def requirenest pool ##{{{
		"""
		method to return all requires within from this component, this component's
		requires, and the requires' requires ...
		return as a hash that stores all unique name indexed objects
		rnest = {:name=>'',:obj=>component}
		rnest = {'name'=>obj}
		"""
		rnest = {};
		pool.each do |required|
			next if (rnest.has_key?(required[:name]));
			rnest[required[:name]] = required[:obj];
			subrnest = self.requirenest(required[:obj].requires);
			subrnest.each_pair do |n,o|
				next if rnest.has_key?(n);
				rnest[n] = o;
			end
		end
		return rnest;
	end ##}}}

	def finalize ##{{{
		"""
		- get all required components,and then evalute it
		"""
		@requires.each do |required|
			fn = required[:name];
			puts "component(#{@name}) required component(#{fn})";
			c = Context.find(:component,fn);
			raise ComponentEvalException.new("required component(#{fn}) not found") if c==nil;
			c.evaluate;
			required[:obj] = c;
		end
	end ##}}}
	def evaluate ##{{{
		"""
		evaluate all bodies in this component, support commands,listed in below global component method
		- required, by calling of this command, will be stored into requires pool first
		"""
		## eval bodies first
		@body.each_pair do |loc,b|
			p =<<-CODE
				begin
					self.instance_eval &b;
				rescue ComponentEvalException => e
					e.process("component evaluate failed: #{loc}");
				end
			CODE
			self.instance_eval p;
			begin
				finalize;
			rescue ComponentEvalException => e
				e.process("component finalize failed(#{@name})");
			end
		end
	end ##}}}


	############################################
	## supported commands
	############################################
	def required n,**opts ##{{{
		opts[:version]='default' if not opts.has_key?(:version);
		required = {
			:name => n.to_s,
			:opts => opts,
			:obj  => nil
		};
		@requires << required;
		return;
	end ##}}}
	def compopt t,*opts ##{{{
		t = t.to_sym;
		@compopts[t] = [] if not @compopts.has_key?(t);
		opts.each do |opt|
			@compopts[t] << opt;
		end
	end ##}}}

	def precompopt t,*opts ##{{{
		t = t.to_sym;
		@precompopts[t] = [] if not @precompopts.has_key?(t);
		opts.each do |opt|
			@precompopts[t] << opt;
		end
	end ##}}}
	def elabopt t,*opts ##{{{
		t = t.to_sym;
		@elabopts[t] = [] if not @elabopts.has_key?(t);
		opts.each do |opt|
			@elabopts[t] << opt;
		end
	end ##}}}
	def simopt t,*opts ##{{{
		t = t.to_sym;
		@simopts[t] = [] if not @simopts.has_key?(t);
		opts.each do |opt|
			@simopts[t] << opt;
		end
	end ##}}}
	def fileset n,**opts ##{{{
		n = n.to_s;
		opts[:filelist] = true if not opts.has_key?(:filelist);
		sfile = caller(1)[0].sub!(/:.+$/,'');
		dir = File.dirname(File.absolute_path(sfile));
		@filesets << {:type=>:source,:dir=>dir,:file=>n,:inlist=>opts[:filelist]};
	end ##}}}
	def includes n ##{{{
		n = n.to_s;
		sfile = caller(1)[0].sub!(/:.+$/,'');
		dir = File.dirname(File.absolute_path(sfile));
		@filesets << {:type=>:includes,:dir=>dir,:file=>n,:inlist=>false};
	end ##}}}

end ##}}}

module ComponentPool ##{{{
	@pool = {};

	def self.remove n ##{{{
		n = n.to_s;
		@pool.delete(n) if @pool.has_key?(n);
		return;
	end ##}}}
	def self.pool; return @pool; end
	def self.find n,create=false ##{{{
		"""
		if n named component registered, then return the registered object, else
		create a new Component with the give name, and register it
		"""
		n = n.to_s;
		if not @pool.has_key?(n)
			if create==true
				@pool[n] = Component.new(n);
			else
				return nil;
			end
		end
		return @pool[n];
	end ##}}}
end ##}}}

def component n,&block ##{{{
	"""
	declare a component, supported commands:
	- required 'ctxt.component', :version=>xxx
	- fileset
	- include
	- compopt
	- elabopt
	- simopt
	"""
	n = n.to_s;
	c = ComponentPool.find(n,true);
	c.addBody(block);
end ##}}}
