## rhload 'lib/exceptions.rb'
rhload 'lib/options.rb'
rhload 'lib/debug.rb'

rhload 'lib/component.rb'
rhload 'lib/config.rb'
rhload 'lib/test.rb'
rhload 'lib/context.rb'
rhload 'lib/projectloader.rb'

class MainEntry ##{{{


	attr :debug;
	attr :context;
	attr :top; ## top is the context name of current project
	attr :imports;
	attr :root;
	attr :entry;
	
	def __setupDebug__ ##{{{
		ProjectLoader.debug= @debug;
		Context.debug= @debug;
		ConfigPool.debug= @debug;
	end ##}}}
	def debug(msg); @debug.print(msg);end
	def initialize r,e,c ##{{{
		"""
		e is simf entry name
		c is top context name
		"""
		@context= nil;
		@top	= c.to_s;
		@option = Options.new();
		@debug  = Debug.new(@option.debug);
		@root   = r.to_s;
		@entry  = e.to_s;
		__setupDebug__;
	end ##}}}
	def run ##{{{
		sig = 0;
		__syncupImports__ if @option.syncup;
		ProjectLoader.loadimports("#{@root}/imports");
		ProjectLoader.loadlocal(@entry);
		__linkContext__;
		__loadPlugins__;
		__finalizeContext__;
		__evaluateUserCmd__;
		##TODO, __loadImports__;
		##TODO, __loadProjectEntry__;
		return sig;
	end ##}}}


	def __linkContext__ ##{{{
		begin
			@context = Context.get(@top);
			raise NoContextException if @context==nil ;
		rescue NoContextException => e
			e.process("no available context(#{@top}) found");
		end
	end ##}}}
	def __syncupImports__ ##{{{
		# TODO, to syncup imported components, this is TBD for now
		# require a component to sync by different tree management tools
		begin
			raise UnSpException;
		rescue UnSpException => e
			e.process("program run into unsupported feature: (syncupImports)");
		end
	end ##}}}
	def __finalizeContext__ ##{{{
		"""
		- evaluate configs, all configs in current context, call configs' body
		-- while evaluating configs, all components instantiated will be evaluted too
		-- others such as simopt are stored in this config.
		"""
		@context.finalize;
	end ##}}}
	def __loadPlugins__ ##{{{
		"""
		to load plugins, such as:
		- xcelium
		"""
		cdir = File.dirname(__FILE__);
		fh = File.open("#{cdir}/../plugin/plugin-config.rb",'r')
		self.instance_eval fh.readlines().join("\n");
	end ##}}}
	def plugin n,&block ##{{{
		@context.loadPlugin 'plugin/'+n+'.rb';
		@context.configPlugin block;
	end ##}}}
	def __evaluateUserCmd__ ##{{{
		"""
		since all flows, components are equipped, now can start evaluate the user commands, like:
		- 'xcelium.run(:testName)'
		"""
		begin
			sig = @context.instance_eval @option.evaluation;
			raise EvalException if sig!=0;
		rescue EvalException => e
			e.process("evaluation of user command(#{@option.evaluation}) failed");
		end
	end ##}}}

end ##}}}
