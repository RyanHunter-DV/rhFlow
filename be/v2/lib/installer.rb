class Installer

	attr :shell;
	attr :home;
	attr :syntax;
	attr :version;

	def __shellhead__
		return '#! /usr/bin/env '+@shell;
	end
	def __rubyhead__
		return '#! /usr/bin/env ruby';
	end
	def __writefile__(fn,cnts)
		fh = File.open(fn,'w');
		cnts.each do |line|
			fh.write(line+"\n");
		end
	end
	def __changemode__(f,m)
		cmd = "chmod u+#{m} #{f}";
		out,err,st = Open3.capture3(cmd);
		raise InstallException.new("file(#{f}) mode change failed:\n\t- #{err}") if st.exitstatus!=0;
		return;
	end
	def __builddir__(d)
		out,err,st = Open3.capture3("mkdir #{d}");
		raise InstallException.new("dir(#{d}) build failed:\n\t- #{err}") if st.exitstatus!=0;
		return;
	end
	def __build__; end
	def install;__build__;end
end
