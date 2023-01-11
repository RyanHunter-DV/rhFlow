rhload 'lib/cmdshell.rb'
class Buildflow ##{{{
	"""
	buildflow, to build the database in out anchor from src node components
	"""

	attr_accessor :context;
	attr_accessor :debug;
	attr_accessor :filelist;
	attr_accessor :outComps;
	attr_accessor :outConfigs;
	attr_accessor :out;

	def initialize ctxt,d
		@out = '';
		@context   = ctxt;
		@debug     = d;
		@filelist  = {};
		@outComps  = {};
		@outConfigs= {};
		@filelist[:incdir] = [];
		@filelist[:file]   = [];
	end

	def __createSubDirs__ r,f ##{{{
		"""
		r: root component dir in out
		f: source file may with subdir
		fd: full subdir, in out
		"""
		dirs = File.dirname(f).split('/');
		fd = r;
		dirs.each do |d|
			fd += '/'+d;
			if not Dir.exists?(fd)
				begin
					@debug.print("create dir: #{fd}");
					rtns = Shell.makedir(fd);
					raise OtherCmdException.new(", makedir failed(#{rtns[0]})") if rtns[1]!=0;
				rescue OtherCmdException => e
					e.process("shell command failed")
				end
			end
		end
		return;
	end ##}}}
	def debugfilelist ##{{{
		@debug.print("start debugging filelist");
		@filelist[:incdir].each do |i|
			@debug.print("filelist[:incdir]-> #{i}");
		end
		@filelist[:file].each do |f|
			@debug.print("filelist[:file]-> #{f}");
		end
	end ##}}}
	def publish sd,sf,r ##{{{
		"""
		sd: source dir
		sf: source file
		r: target component root dir
		"""
		@debug.print("rootdir: #{r}");
		@debug.print("sourcefile: #{sf}");
		@debug.print("sourcedir: #{sd}");
		begin
			__createSubDirs__(r,sf);
			t = "#{r}/#{File.dirname(sf)}";
			rtns = Shell.copy("#{sd}/#{sf}",t);
			raise OtherCmdException.new(",copy failed(#{rtns[0]})",rtns[1]) if rtns[1] != 0;
			incdir = File.dirname("#{sd}/#{sf}");
			@filelist[:incdir] << incdir if not @filelist[:incdir].include?(incdir);
			realfs = Shell.find(t,File.basename(sf),'-maxdepth 1');
			realfs.each do |rf|
				@filelist[:file] << rf;
			end
		rescue OtherCmdException => e
			e.process("shell command failed");
		end
	end ##}}}

	def __publishcomponent__ c,r ##{{{
		"""
		c: component object
		r: root component path in out dir
		"""
		c.filesets.each do |fs|
			publish(fs[:dir],fs[:file],r) if fs[:type] == :source;
		end
	end ##}}}

	def __buildComponents__ config ##{{{
		"""
		to build all components from source to out anchor.
		"""
		## TODO, out = File.absolute_path("#{$projectRoot}/#{$outAnchor}");
		## TODO, @outComps[:root] = "#{out}/components";
		## TODO, config.comps.each_pair do |inst,comp|
		## TODO, 	compdir = "#{comp.name}-#{inst}";
		## TODO, 	@outComps[compdir] = @outComps[:root]+'/'+compdir;
		## TODO, 	@debug.print("building component in (#{@outComps[compdir]})");
		## TODO, 	Shell.makedir(@outComps[compdir]);
		## TODO, 	__publishcomponent__(comp,@outComps[compdir]);
		## TODO, end
		begin
			rtns = Shell.makedir(@out);
			raise OtherCmdException.new(", build out failed(#{rtns[0]})") if rtns[1]!=0;
			@debug.print("building component root dir(#{@outComps[:root]})");
			rtns = Shell.makedir(@outComps[:root]);
			raise OtherCmdException.new(", build out failed(#{rtns[0]})") if rtns[1]!=0;
			config.comps.each_pair do |inst,comp|
				@debug.print("building component in (#{comp.outpath})");
				rtns = Shell.makedir(comp.outpath);
				raise OtherCmdException.new(", build out failed(#{rtns[0]})") if rtns[1]!=0;
				__publishcomponent__(comp,comp.outpath);
			end
		rescue OtherCmdException => e
			e.process("buildComponents failed");
		end
		debugfilelist;
	end ##}}}
	def __buildConfig__ config ##{{{
		"""
		build dirs for configs, and setup filelist for that config
		build dir: out/config/<config>/build
		"""
		## TODO, out = File.absolute_path("#{$projectRoot}/#{$outAnchor}");
		## TODO, @outConfigs[:root] = "#{out}/configs";
		## TODO, @outConfigs[config.name]= "#{@outConfigs[:root]}/#{config.name}";
		## TODO, @outConfigs["#{config.name}.build"]= @outConfigs[config.name]+'/build';
		## TODO, @outConfigs["#{config.name}.sim"]  = @outConfigs[config.name]+'/sim';
		begin
			@debug.print("makdir: #{@outConfigs[:root]}, #{@outConfigs[config.name]}");
			build = "#{@outConfigs[config.name]}/build";
			sim   = "#{@outConfigs[config.name]}/sim";
			@debug.print("makdir: #{build}, #{sim}");
			rtns = Shell.makedir(@outConfigs[:root],@outConfigs[config.name],build,sim);
			raise OtherCmdException.new(",makedir failed(#{rtns[0]})",rtns[1]) if rtns[1]!=0;
		rescue OtherCmdException => e
			e.process("build config failed");
		end
		config.filelist= @filelist;
	end ##}}}
	def run config ##{{{
		"""
		to run the build flow,
		"""
		__buildComponents__(config);
		__buildConfig__(config);
	end ##}}}
end ##}}}
