class AppInstaller

	attr :shell;
	attr :home;
	attr :syntax;
	attr :version;

	# _s, shell
	# _h, home
	def initialize _s,_h
		@shell = _s;
		@home  = _h;
		@shell = 'bash' if @shell=='sh'; # sh is same as bash
		@syntax = ShellSyntax.new(@shell);
		@version= 'v1';
	end

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
	def appShellInstall
		cnts = [];
		cnts << __shellhead__;
		cnts << @syntax.setvar('cdir',@home+'/bin');
		cnts << @syntax.setvar('version',@version);
		cnts << @syntax.setenv('SHELLTYPE',@shell);
		cnts << "source ${cdir}/app-${version}.#{@shell}";
		puts "installing file: #{@home}/bin/appShel.#{@shell}";
		__writefile__(File.join(@home,"bin/appShell.#{@shell}"),cnts);
	end

	def __builddir__(d)
		out,err,st = Open3.capture3("mkdir #{d}");
		raise InstallException.new("dir(#{d}) build failed:\n\t- #{err}") if st.exitstatus!=0;
		return;
	end

	def appInstall
		cnts = [];
		cnts << __shellhead__;
		cnts << @syntax.setvar('apphome',@home);
		cnts << @syntax.setvar('argumentCommands','`${apphome}/accessory/__optionProcess__.rb $@`');
		cnts << 'eval ${argumentCommands}';
		cnts << %Q|echo "${cmd} tool: ${tool}, version: ${version}"|;
		cnts << @syntax.setvar('appConfig','${apphome}/tools/${tool}/${version}/app.config');
		cnts << @syntax.condition("${cmd} == ''");
		cnts << %Q|\techo "Error, invalid input options: $@"|;
		cnts << %Q|\treturn 3|;
		cnts << @syntax.conditione();
		cnts << @syntax.condition("${cmd} == 'setup'");
		cnts << %Q|\tmkdir -p ${apphome}/tools/${tool}|;
		cnts << %Q|\tmkdir -p ${apphome}/tools/${tool}/${version}|;
		cnts << %Q|\ttouch ${apphome}/tools/${tool}/${version}/app.config|;
		currentlink = "${apphome}/tools/${tool}/current"
		cnts << @syntax.condition("! -e #{currentlink}","\t");
		cnts << %Q|\t\tln -s ${apphome}/tools/${tool}/${version} #{currentlink}|;
		cnts << @syntax.conditione("\t");
		cnts << @syntax.conditione();
		cnts << @syntax.condition('! -e $appConfig');
		cnts << %Q|\techo "Error, no app.config file found for: ${appConfig}"|;
		cnts << %Q|\techo "you can setup your config through: app setup ${tool}/${version}"|;
		cnts << %Q|\treturn 3|;
		cnts << @syntax.conditione();

		cnts << @syntax.setvar('setupCommands','`${apphome}/accessory/__appConfigProcess__.rb ${appConfig} ${cmd}`');
		cnts << @syntax.condition('! -z "${setupCommands}"');
		cnts << %Q|\teval $setupCommands|;
		cnts << @syntax.conditione();
		cnts << %Q|echo "Success, ${cmd} completed"|;
		cnts << %Q|return 0|;
		puts "installing file: #{@home}/bin/app-#{@version}.#{@shell}";
		__writefile__(File.join(@home,"bin/app-#{@version}.#{@shell}"),cnts);
	end
	def accessoryInstall
		cnts = [];
		# x -> executor, need x mode
		# f -> file, normal
		accessories = {'__optionProcess__': 'x','__appConfigProcess__': 'x','xmlprocessor': 'f'};
		libdir = File.join($toolHome,'lib');
		accessories.each_pair do |accessory,mode|
			puts "installing file: #{@home}/accessory/#{accessory}.rb";
			fh = File.open(libdir+"/#{accessory}.raw",'r');
			cnts = fh.readlines();
			cnts.each do |l|
				l.chomp!;
			end
			__writefile__(File.join(@home,"accessory/#{accessory}.rb"),cnts);
			__changemode__(File.join(@home,"accessory/#{accessory}.rb"),'x') if mode=='x';
		end
		#
	end

	def __buildbin__
		__builddir__(File.join(@home,'bin'));
		__builddir__(File.join(@home,'accessory'));
		__builddir__(File.join(@home,'tools'));
		appShellInstall;
		appInstall;
		accessoryInstall;
	end

	def install
		__buildbin__;
	end

end
