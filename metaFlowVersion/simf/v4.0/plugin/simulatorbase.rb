class SimulatorBase
	attr_accessor :symbol; # simulator symbol, like :vcs, :xlm
	attr_accessor :optformat;

	attr :bf; ## buildflow object
	attr :context; ## the context object
	attr :debug;
	attr :filelist;
	attr :logfile;
	attr :cmdfiles;


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
	def initialize s,ctx,d
		@symbol = s.to_sym;
        @context = ctx;
		@debug   = d;
        @bf = Buildflow.new(@context,@debug);
		@filelist= {};
		@filelist[:name] = 'default.list';
		@filelist[:content] = [];
		@optformat = {}; ## option formatter for different simulaotr, set by its subclass
		__initLogs__;
		__initCmds__;
	end
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
		flist = "#{@bf.outConfigs["#{c.name}.build"]}/#{@filelist[:name]}";
		Shell.generate(:file,flist,*(@filelist[:content]));
	end ##}}}
    def build cn ##{{{
        """
        run build by xcelium flow, i.e. xcelium.build(:configName)
        cn is the config name
        """
		@debug.print("call buildflow.run");
        @bf.run(cn);
		## @debug.print("TODO, temporary set return of build to fail");
		return 0;
    end ##}}}
	def compile tn ##{{{
		"""
		compile the built database through xcelium
		"""
		begin
			test  = @context.findlocal(:test,tn);
			raise CompileException.new(", test(:#{tn}) not found") if test==nil;
			build(test.config.name);
			generateFilelist(test.config);
			generateCompileCommand(test);
			flag = "#{test.config.name}.build";
			puts "#{@symbol}.compile ......";
			cmd  = "source ./#{@cmdfiles[:comp]}";
			@debug.print("path: #{@bf.outConfigs[flag]}");
			@debug.print("cmd: #{cmd}");
			rtns = Shell.exec(@bf.outConfigs[flag],cmd);
			raise CompileException.new(", call simulator failed(#{rtns[0]})") if rtns[1]!=0;
		rescue CompileException => e
			e.process("compile failed");
		end
		return 0;
	end ##}}}
	def generateCompileCommand t ##{{{
		"""
		collecting user options for compile, from config, component
		"""
		compopts    = [];
		precompopts = [];
		cmds = [];

		compopts.append(*__getCompopts__(t.config,@symbol));
		compopts.append(*__getCompopts__(t.config,:all));
		precompopts.append(*__getPreCompopts__(t.config,@symbol));
		precompopts.append(*__getPreCompopts__(t.config,:all));

		cmds.append(*__builtinCompCmd__);
		cmds.append(*precompopts);
		## for now, all filelist option are the same among different simulators
		cmds.append("-f #{@filelist[:name]}"); 
		cmds.append(*compopts);
		flag = "#{t.config.name}.build";
		cmdf = "#{@bf.outConfigs[flag]}/#{@cmdfiles[:comp]}";
		Shell.generate(:file,cmdf,cmds.join(' '));
	end ##}}}
	def __getCompopts__ o,s ##{{{
		opts = [];
		return opts if not o.compopts.has_key?(s);
		o.compopts[s].each do |opt|
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
end