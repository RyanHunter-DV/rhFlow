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
		@libpath={};
		begin
			raise EnvException.new(", env(CDS_INST_DIR) not set") if not ENV['CDS_INST_DIR'];
			@libpath[:comp] = "./:#{ENV['CDS_INST_DIR']}/tools/inca/lib";
			@libpath[:comp] += ":#{ENV['CDS_INST_DIR']}/tools/lib";
			@libpath[:comp] += ":#{ENV['CDS_INST_DIR']}/tools/lib/64bit";

			@libpath[:sim] = "./:#{ENV['CDS_INST_DIR']}/tools/inca/lib";
			@libpath[:sim] += ":#{ENV['CDS_INST_DIR']}/tools/lib";
			@libpath[:sim] += ":#{ENV['CDS_INST_DIR']}/tools/lib/64bit";
		rescue EnvException => e
			e.elevel= :WARNING;
			@libpath[:comp] = './';
			@libpath[:sim]  = './';
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
		cmds << Shell.setenv('LD_LIBRARY_PATH',@libpath[:comp])+';';
		cmds << 'xmelab';
		cmds << '-64BIT'
		cmds << "-LIBNAME #{@worklib}";
		cmds << "-LOGFILE #{@logfile[:elab]}";
		cmds << "-ACCESS #{@access}";
		cmds << "#{@worklib}.#{@worktop}";
		cmds << "-SNAPSHOT #{@snapshot}";
		return cmds;
	end ##}}}

	def __preparelibs__ config ##{{{
		"""
		for xlm, need link the libs from build dir to sim dir
		"""
		simflag   = "#{config.name}/sim";
		buildflag = "#{config.name}/build";
		begin
			srcfiles = ["hdl.var","cds.lib","#{@worklib}"];
			srcfiles.each do |sf|
				sffull = "#{@outConfigs[buildflag]}/#{sf}";
				rtns = Shell.link(@outConfigs[simflag],sffull,sf);
				raise OtherCmdException.new("link(#{sf}) failed(#{rtns[0]})") if rtns[1]!=0;
			end
		rescue OtherCmdException => e
			e.process();
		end
	end ##}}}
	def __builtinSimCmd__ config ##{{{
		cmds = [];
		cmds << Shell.setenv('LD_LIBRARY_PATH',@libpath[:sim])+';';
		cmds << 'xmsim';
		cmds << '-64BIT';
		cmds << '-RUN';
		cmds << "-LOGFILE #{@logfile[:sim]}";
		cmds << "#{@snapshot}";
		__preparelibs__(config);
		return cmds;
	end ##}}}
	def __buildWorklib__ config ##{{{
		buildflag = "#{config.name}.build";
		hdl = File.join(@outConfigs[buildflag],'hdl.var');
		cds = File.join(@outConfigs[buildflag],'cds.lib');
		Shell.generate(:file,hdl,"DEFINE WORK #{@worklib}");
		Shell.generate(:file,cds,"DEFINE #{@worklib} ./#{@worklib}");
		Shell.makedir(File.join(@outConfigs[buildflag],@worklib));
	end ##}}}
	def __syncUserConfigs__ config ##{{{
		@worktop = config.worktop if config.worktop!='';
		#TODO, other user configs can be added here
	end ##}}}
	def preRunCompile config ##{{{
		__syncUserConfigs__(config);
		__buildWorklib__(config);
	end ##}}}
end ##}}}
