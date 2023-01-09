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

	def initialize ctxt,d
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
				@debug.print("create dir: #{fd}");
				Shell.makedir(fd);
			end
		end
		return;
	end ##}}}
	def debugfilelist ##{{{
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
		out = File.absolute_path("#{$projectRoot}/#{$outAnchor}");
		@outComps[:root] = "#{out}/components";
		Shell.makedir(out,@outComps[:root]);
		config.comps.each_pair do |inst,comp|
			compdir = "#{comp.name}-#{inst}";
			@outComps[compdir] = @outComps[:root]+'/'+compdir;
			@debug.print("building component in (#{@outComps[compdir]})");
			Shell.makedir(@outComps[compdir]);
			__publishcomponent__(comp,@outComps[compdir]);
		end
		debugfilelist;
	end ##}}}
	def __buildConfig__ config ##{{{
		"""
		build dirs for configs, and setup filelist for that config
		build dir: out/config/<config>/build
		"""
		out = File.absolute_path("#{$projectRoot}/#{$outAnchor}");
		@outConfigs[:root] = "#{out}/configs";
		@outConfigs[config.name]= "#{@outConfigs[:root]}/#{config.name}";
		@outConfigs["#{config.name}.build"]= @outConfigs[config.name]+'/build';
		@outConfigs["#{config.name}.sim"]  = @outConfigs[config.name]+'/sim';
		begin
			@debug.print("makdir: #{@outConfigs[:root]}, #{@outConfigs[config.name]}");
			rtns = Shell.makedir(@outConfigs[:root],@outConfigs[config.name],@outConfigs["#{config.name}.build"]);
			raise OtherCmdException.new(",makedir failed(#{rtns[0]})",rtns[1]) if rtns[1]!=0;
		rescue OtherCmdException => e
			e.process("build config failed");
		end
		config.filelist= @filelist;
	end ##}}}
	def run cn ##{{{
		"""
		to run the build flow,
		"""
		begin
			raise BuildException.new(", no context set") if @context==nil;
			config = @context.findlocal(:config,cn);
			raise BuildException.new(", no config(#{cn}) in context(#{@context.name})") if config==nil;
			__buildComponents__(config);
			__buildConfig__(config);
		rescue BuildException => e
			e.process("buildflow failed");
		end
	end ##}}}
end ##}}}
