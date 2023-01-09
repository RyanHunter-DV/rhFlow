rhload 'plugin/buildflow.rb'
rhload 'plugin/simulatorbase.rb'

class Xcelium < SimulatorBase ##{{{

	attr_accessor :worklib;
	attr_accessor :worktop;
	attr_accessor :snapshot;
	attr_accessor :access;
	attr_accessor :libpath;
	def __setupOptionFormats__ ##{{{
		@optformat[:incdir] = '-incdir ';
	end ##}}}
	def __setuplibpath__ ##{{{
		begin
			raise EnvException.new(", env(CDS_INST_DIR) not set") if not ENV['CDS_INST_DIR'];
			@libpath = "./:#{ENV['CDS_INST_DIR']}/tools/inca/lib";
			@libpath += ":#{ENV['CDS_INST_DIR']}/tools/lib";
			@libpath += ":#{ENV['CDS_INST_DIR']}/tools/lib/64bit";
		rescue EnvException => e
			e.elevel= :WARNING;
			@libpath = './';
			e.process("use default libpath(./)");
		end
	end ##}}}
    def initialize ctx,d ##{{{
		super(:xlm,ctx,d);
		__setupOptionFormats__;
		__setuplibpath__;
		@worklib = 'ncvlog_lib';
		@worktop = 'top';
		@snapshot= @worklib+'.'+@worklib+':'+@worklib;
		@access  = 'rwc';
    end ##}}}

	def __builtinCompCmd__ ##{{{
		cmds = [];
		cmds << 'xmvlog';
		cmds << '-64BIT';
		cmds << '-SV';
		cmds << "-LOGFILE #{@logfile[:comp]}";
		return cmds;
	end ##}}}
	def __builtinElabCmd__ ##{{{
		cmds = [];
		cmds << Shell.setenv('LD_LIBRARY_PATH',@libpath+default)+';';
		cmds << 'xmelab';
		cmds << '-64BIT'
		cmds << "-LIBNAME #{@worklib}";
		cmds << "-LOGFILE #{@logfile[:elab]}";
		cmds << "-ACCESS #{@access}";
		cmds << "#{@worklib}.#{@worktop}";
		cmds << "-SNAPSHOT #{@snapshot}";
		return cmds;
	end ##}}}
	def __buildWorklib__ config ##{{{
		buildflag = "#{config.name}.build";
		hdl = File.join(@bf.outConfigs[buildflag],'hdl.var');
		cds = File.join(@bf.outConfigs[buildflag],'cds.lib');
		Shell.generate(:file,hdl,"DEFINE WORK #{@worklib}");
		Shell.generate(:file,cds,"DEFINE #{@worklib} ./#{@worklib}");
		Shell.makedir(File.join(@bf.outConfigs[buildflag],@worklib));
	end ##}}}
	def __syncUserConfigs__ config ##{{{
		@worktop = config.worktop if config.worktop;
		#TODO, other user configs can be added here
	end ##}}}
	def preRunCompile config ##{{{
		__syncUserConfigs__(config);
		__buildWorklib__(config);
	end ##}}}
end ##}}}
