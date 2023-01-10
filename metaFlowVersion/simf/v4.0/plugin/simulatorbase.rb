class SimulatorBase
	attr_accessor :symbol; # simulator symbol, like :vcs, :xlm
	attr_accessor :optformat;

	attr :bf; ## buildflow object
	attr :context; ## the context object
	attr :debug;
	attr :filelist;
	attr :logfile;
	attr :cmdfiles;

	attr :outAnchor;
	attr :outComps;
	attr :outConfigs;
	attr :dirset;

	def __initLogs__ ##{{{
		@logfile={};
		@logfile[:comp] = 'default_compile.log';
		@logfile[:elab] = 'default_elaborate.log';
		@logfile[:sim]  = 'default_sim.log';
	end ##}}}
	def __initCmds__ ##{{{
		@cmdfiles={};
		@cmdfiles[:comp] = 'compile_command';
		@cmdfiles[:elab] = 'elaborate_command';
		@cmdfiles[:sim]  = 'sim_command';
	end ##}}}
	def __initOuts__ ##{{{
		@outAnchor = '';
		@outComps  = {};
		@outConfigs= {};
		@dirset = false;
	end ##}}}
	def initialize s,ctx,d ##{{{
		@symbol = s.to_sym;
        @context = ctx;
		@debug   = d;
        @bf = Buildflow.new(@context,@debug);
		@filelist= {};
		@filelist[:name] = 'default.list';
		@filelist[:content] = [];
		@optformat = {}; ## option formatter for different simulaotr, set by its subclass
		__initOuts__;
		__initLogs__;
		__initCmds__;
	end ##}}}

	###########################
	## virtual methods
	###########################
	def __builtinCompCmd__;end
	def __builtinElabCmd__;end
	def __builtinSimCmd__;end
	def preRunCompile; end

	def generateFilelist c ##{{{
		"""
		filelist generated from config's filelist
		"""
		c.filelist[:incdir].each do |inc|
			@filelist[:content] << @optformat[:incdir]+inc;
		end
		c.filelist[:file].each do |f|
			@filelist[:content] << f;
		end
		flist = "#{@outConfigs["#{c.name}.build"]}/#{@filelist[:name]}";
		Shell.generate(:file,flist,*(@filelist[:content]));
	end ##}}}

	def __setupDirs__ config ##{{{
		return if @dirset;
		@dirset = true;
		@outAnchor = File.absolute_path("#{$projectRoot}/#{$outAnchor}");
		@outComps[:root] = "#{@outAnchor}/components";
		config.comps.each_pair do |inst,comp|
			compdir = "#{comp.name}-#{inst}";
			@outComps[compdir] = @outComps[:root]+'/'+compdir;
		end
		@outConfigs[:root] = "#{@outAnchor}/configs";
		@outConfigs[config.name]= "#{@outConfigs[:root]}/#{config.name}";
		@outConfigs["#{config.name}.build"]= @outConfigs[config.name]+'/build';
		@outConfigs["#{config.name}.sim"]  = @outConfigs[config.name]+'/sim';
	end ##}}}
    def build n,**opts ##{{{
        """
        run build by xcelium flow, i.e. xcelium.build(:configName)
        cn is the config name
        """
		@debug.print("call buildflow.run");
		begin
			if opts.has_key?(:usetest);
				test  = @context.findlocal(:test,n);
				raise BuildException.new(", test(#{n}) not found in context(#{@context.name})") if test==nil;
				cn = test.config.name;
			else
				cn = n 
			end
			raise BuildException.new(", no context set") if @context==nil;
			config = @context.findlocal(:config,cn);
			raise BuildException.new(", no config(#{cn}) in context(#{@context.name})") if config==nil;
			__setupDirs__(config);
			@bf.outConfigs= @outConfigs;
			@bf.outComps= @outComps;
			@bf.out= @outAnchor;
        	@bf.run(config);
			generateFilelist(config);
		rescue BuildException => e
			e.process("build failed");
		end
		return 0;
    end ##}}}
	def compile tn ##{{{
		"""
		compile the built database through xcelium
		"""
		begin
			test  = @context.findlocal(:test,tn);
			raise CompileException.new(", test(:#{tn}) not found") if test==nil;
			## build(test.config.name);
			__setupDirs__(test.config);
			@debug.print("call generateCompileCommand");
			generateCompileCommand(test);
			@debug.print("call runCompile");
			runCompile(test);
			if @symbol == :xlm
				@debug.print("call generateElaborateCommand");
				generateElaborateCommand(test);
				@debug.print("call runElaborate");
				runElaborate(test);
			end
		rescue CompileException => e
			e.process("compile failed");
		end
		return 0;
	end ##}}}
	def runCompile test ##{{{
		preRunCompile test.config;
		flag = "#{test.config.name}.build";
		puts "#{@symbol}.compile ......";
		cmd  = "source ./#{@cmdfiles[:comp]}";
		@debug.print("path: #{@bf.outConfigs[flag]}");
		@debug.print("cmd: #{cmd}");
		rtns = Shell.exec(@bf.outConfigs[flag],cmd);
		raise CompileException.new(", call simulator(compile) failed(#{rtns[0]})") if rtns[1]!=0;
	end ##}}}
	def runElaborate test ##{{{
		flag = "#{test.config.name}.build";
		puts "#{@symbol}.elaborate ......";
		cmd  = "source ./#{@cmdfiles[:elab]}";
		@debug.print("path: #{@bf.outConfigs[flag]}");
		@debug.print("cmd: #{cmd}");
		rtns = Shell.exec(@bf.outConfigs[flag],cmd);
		raise CompileException.new(", call simulator(elaborate) failed(#{rtns[0]})") if rtns[1]!=0;
	end ##}}}
	def runSim test ##{{{
		flag = "#{test.config.name}.sim";
		puts "#{@symbol}.simulation ......";
		cmd  = "source ./#{@cmdfiles[:sim]}";
		@debug.print("path: #{@bf.outConfigs[flag]}");
		@debug.print("cmd: #{cmd}");
		rtns = Shell.exec(@bf.outConfigs[flag],cmd);
		raise CompileException.new(", call simulator(simulation) failed(#{rtns[0]})") if rtns[1]!=0;
	end ##}}}
	def generateCompileCommand t ##{{{
		"""
		collecting user options for compile, from config, component
		"""
		compopts    = [];
		precompopts = [];
		cmds = [];

		compopts.append(*__getopts__(:comp,t.config,@symbol));
		compopts.append(*__getopts__(:comp,t.config,:all));
		precompopts.append(*__getPreCompopts__(t.config,@symbol));
		precompopts.append(*__getPreCompopts__(t.config,:all));

		cmds.append(*__builtinCompCmd__);
		cmds.append(*precompopts);
		## for now, all filelist option are the same among different simulators
		cmds.append("-f #{@filelist[:name]}"); 
		cmds.append(*compopts);
		cmd = cmds.join(' ');
		flag = "#{t.config.name}.build";
		cmdf = "#{@outConfigs[flag]}/#{@cmdfiles[:comp]}";
		@debug.print("generateCompileCommand: #{cmd}");
		Shell.generate(:file,cmdf,cmd);
	end ##}}}
	def generateElaborateCommand t ##{{{
		elabopts    = [];
		cmds = [];

		elabopts.append(*__getopts__(:elab,t.config,@symbol));
		elabopts.append(*__getopts__(:elab,t.config,:all));

		cmds.append(*__builtinElabCmd__);
		cmds.append(*elabopts);
		flag = "#{t.config.name}.build";
		cmdf = "#{@outConfigs[flag]}/#{@cmdfiles[:elab]}";
		Shell.generate(:file,cmdf,cmds.join(' '));
	end ##}}}
	def __getopts__ t,o,s ##{{{
		opts   =[];
		srcopts={};
		if t==:comp
			srcopts = o.compopts;
		elsif t==:elab
			srcopts = o.elabopts;
		else
			srcopts = o.simopts;
		end
		return opts if not srcopts.has_key?(s);
		srcopts[s].each do |opt|
			opts << opt;
		end
		return opts;
	end ##}}}
	def __getPreCompopts__ o,s ##{{{
		opts = [];
		return opts if not o.compopts.has_key?(s);
		o.precompopts[s].each do |opt|
			opts << opt;
		end
		return opts;
	end ##}}}

	def sim tn ##{{{
		"""
		sim assume that compile has already passed
		"""
		begin
			test  = @context.findlocal(:test,tn);
			raise SimException.new(", test(#{tn}) not found") if test==nil;
			__setupDirs__(test.config);
			generateSimCommand(test);
			runSim(test);
		rescue SimException => e
			e.process("simulation failed");
		end
	end ##}}}
	def generateSimCommand test ##{{{
		simopts = [];
		cmds = [];

		simopts.append(*__getopts__(:sim,test,@symbol));
		simopts.append(*__getopts__(:sim,test,:all));
		simopts.append(*__getopts__(:sim,test.config,@symbol));
		simopts.append(*__getopts__(:sim,test.config,:all));

		cmds.append(*__builtinSimCmd__);
		cmds.append(*simopts);

		flag = "#{test.config.name}.sim";
		cmdf = "#{@outConfigs[flag]}/#{@cmdfiles[:sim]}";
		Shell.generate(:file,cmdf,cmds.join(' '));
	end ##}}}
	def run tn ##{{{
		"""
		build -> compile -> sim
		"""
		build(tn,:usetest=>true);
		compile(tn);
		sim(tn);
	end ##}}}
end
