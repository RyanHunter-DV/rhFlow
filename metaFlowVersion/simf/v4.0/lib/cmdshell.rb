require 'open3'
module Shell ##{

	@type = :bash;

	## t is used to choose to get the setenv command or
	## directly run the setenv command
	## t=:get, will return the command
	## t=:run, will run this command directly
	def self.setenv var,val,t=:get ##{
		line = '';
		case (@type)
		when :bash
			line = "export #{var}=#{val}:$#{var}";
		when :csh
			line = "setenv #{var} #{val}:$#{var}";
		end
		case (t)
		when :get
			## puts "debug line: #{line}";
			return line;
		when :run
			system("#{line}");
		else
			$stderr.puts "Error, type(#{t}) of setenv not supported";
		end
	end ##}

	def self.getfiles f,l=nil ##{
		cmd = '';
		cmd += "cd #{l};" if (l);
		cmd += "ls #{f}";
		fs = `#{cmd}`.split("\n");
		return fs;
	end ##}

	def self.getAbsoluteFiles f,l=nil ##{
		rtns = [];
		fs = self.getfiles f,l
		fs.each do |f|
			rtns << File.join(l,f);
		end
		return rtns;
	end ##}

	## support multiple paths as args
	def self.makedir *paths ##{
		paths.each do |p|
			next if Dir.exists?(p);
			cmd = "mkdir #{p}";
			out,err,st = Open3.capture3(cmd);
			return [err,st.exitstatus] if st.exitstatus!=0;
		end
		return ['',0];
	end ##}
	def self.link path,src,link ##{{{
		cmd = "cd #{path};ln -s #{src} #{link}";
		return ['',0] if File.exists?("#{path}/#{link}");
		## @debug.print("cmd: cd #{path};ln -s #{src} #{link}");
		out,err,st = Open3.capture3(cmd);
		return [err,st.exitstatus] if st.exitstatus!=0;
		return ['',0];
	end ##}}}

	def self.createDir d ##{
		pd = File.dirname(d);
		self.createDir(pd) unless Dir.exists?(pd);
		self.makedir d;
		return;
	end ##}

	def self.copy s,t ##{
		tdir = File.dirname(t);
		self.createDir(tdir);
		cmd = "cp #{s} #{t}";
		out,err,st = Open3.capture3(cmd);
		return [err,st.exitstatus];
	end ##}

	def self.exec path,cmd,visible=true ##{
		e = "cd #{path};#{cmd}";
		## puts "shell: #{e}";
		out,err,st = Open3.capture3(e);
		puts out if visible;
		return [err.chomp!,st.exitstatus]
	end ##}
	def self.isFakeReport line ##{{{
		fake = false;
		fake = true if /UVM_ERROR +: +0/.match(line);
		fake = true if /UVM_FATAL +: +0/.match(line);
		return fake;
	end ##}}}
	def self.__processSimOutputs__ outs,eflags ##{{{
		rtns = {:sig=>0,:errors=>[]};
		outs.each do |line|
			eflags.each do |eflag|
				p = Regexp.new("^#{eflag}");
				if p.match(line)
					rtns[:errors] << line unless self.isFakeReport(line);
				end
			end
		end
		rtns[:sig] = 1 unless (rtns[:errors].empty?);
		return rtns;
	end ##}}}

	def edasimSub path,cmd,eflag ##{{{
		eflags = ['UVM_ERROR ','UVM_FATAL ']; ## builtin for all simulator
		eflags.append(*eflag);
		e = "cd #{path};#{cmd}";
		out,err,st = Open3.capture3(e);
		rtns = self.__processSimOutputs__(out.split("\n"),eflags);
		return rtns;
	end ##}}}

	def edasimMain pid ##{{{
		begin
			Process.wait(pid);
		rescue SignalException => e
			puts "get SignalException, terminate simulation";
			Process.kill("TERM",pid);
		end
	end ##}}}
	def self.edasim path,cmd,eflag ##{{{
		"""
		run sim and process the outputs according to elfag
		"""
		pid = Process.fork;
		if pid == nil
			rtns = self.edasimSub(path,cmd,eflag);
		else
			self.edasimMain(pid);
		end
		return rtns;
	end ##}}}

	def self.generate t=:file,n='<null>',*cnts ##{
		##puts "DEBUG, generate file: #{n}"
		##puts "DEBUG, contents: #{cnts}"
		case (t)
		when :file
			fh = File.open(n,'w');
			cnts.each do |l|
				fh.write(l+"\n");
			end
			fh.close;
		else
			$stderr.puts "Error, not support type(#{t})"
		end
	end ##}

	def self.find p,n,ext ##{{{
		"""
		find files according to the given path and name
		"""
		cmd = "find -L #{File.absolute_path(p)} #{ext} -name \"#{n}\"";
		### puts "find cmd: #{cmd}"
		fs,err,st = Open3.capture3(cmd);
		## puts "fs: #{fs}"
		## puts "err: #{err}"
		## puts "st: #{st}"
		if fs==''
			fs = []
		else
			fs = fs.split("\n");
		end
		## puts "[DEBUG], fs: #{fs}"
		return fs;
	end ##}}}

end ##}
