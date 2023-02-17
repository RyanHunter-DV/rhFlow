class BootInstaller < Installer
	attr :shell;
	attr :home;
	attr :syntax;
	attr :version;

	def initialize _s,_h
		@shell = _s;
		@home  = _h;
		@shell = 'bash' if @shell=='sh'; # sh is same as bash
		@syntax = ShellSyntax.new(@shell);
		@version= 'v1';
	end

	def bootShellInstall
		cnts = [];
		cnts << __shellhead__;
		cnts << @syntax.setvar('cdir',@home+'/bin');
		cnts << @syntax.setvar('version',@version);
		cnts << @syntax.setenv('SHELLTYPE',@shell);
		cnts << "source ${cdir}/bootenv-${version}.#{@shell}";
		puts "installing file: #{@home}/bin/bootShell.#{@shell}";
		__writefile__(File.join(@home,"bin/bootShell.#{@shell}"),cnts);
	end
	def bootInstall
		cnts = [];
		cnts << __shellhead__;
		cnts << @syntax.setvar('boothome',@home);
		cnts << @syntax.setvar('workhome',"`realpath .`");
		cnts << @syntax.setvar('project',"`basename ${workhome}`");
		cnts << @syntax.setvar('argumentCommands',"`${boothome}/accessory/__optionProcess__.rb ${SHELLTYPE} $@`");
		cnts << %Q|eval ${argumentCommands}|;
		cnts << @syntax.setvar('envfile',"${workhome}/__be__/${envview}.anchor");
		cnts << @syntax.condition('! -e ${envfile}');
		cnts << %Q|\techo "the specified env file not exists ${envfile}"|;
		cnts << %Q|\treturn 3|;
		cnts << @syntax.conditione();

		cnts << @syntax.setvar('nterm',"/usr/bin/gnome-terminal");
		cnts << %Q|echo "project: ${project}"|;
		cnts << @syntax.setvar('termopts',%q|"--title \"[booted] ${project}\" --hide-menubar --geometry=120x40+40+40"|);
		cnts << @syntax.setvar('setupcmd',%Q|"export SHELLTYPE=#{@shell}"|);
		cnts << @syntax.setvar('bootcmd',%Q|"source ${boothome}/bin/__bootinNewTerminal__.${SHELLTYPE} ${envfile} ${workhome}"|);
		cnts << @syntax.setvar('logincmd',%q|"${setupcmd};${bootcmd};exec bash"|);
		cnts << @syntax.setvar('localcmd',"${bootcmd};");

		cnts << @syntax.condition('${newterm} == 1');
		cnts << %Q|\techo "booting project env with new terminal"|;
		cnts << "\t"+%q|fullcmd="${nterm} ${termopts} -- ${SHELLTYPE} -c \"${logincmd}\""|;
		cnts << %Q|else|;
		cnts << %Q|\techo "booting project env with local terminal"|;
		cnts << %Q|\tfullcmd="${localcmd}"|;
		cnts << @syntax.conditione();
		cnts << %Q|echo ${fullcmd}|;
		cnts << %Q|eval ${fullcmd}|;

		puts "installing file: #{@home}/bin/bootenv-#{@version}.#{@shell}";
		__writefile__(File.join(@home,"bin/bootenv-#{@version}.#{@shell}"),cnts);

		## __bootinNewTerminal__ install
		cnts = [];
		cnts << __shellhead__;
		cnts << @syntax.setvar('envfile','$1');
		cnts << @syntax.setvar('workhome','$2');
		cnts << @syntax.setenv('PROJECT_HOME','${workhome}');
		cnts << %Q|shopt -s expand_aliase| if @shell=='bash'; ## for bash only
		cnts << @syntax.alias('app',File.join($apphome,"bin/appShell.#{@shell}"));
		cnts << @syntax.setvar('info',%q(`cat ${envfile} | sed -e 's/$/;/'`));
		cnts << @syntax.setvar('cmdl',%q|"${info}"|);
		cnts << %q|eval ${cmdl}|;

		puts "installing file: #{@home}/bin/__bootinNewTerminal__.#{@shell}";
		__writefile__(File.join(@home,"bin/__bootinNewTerminal__.#{@shell}"),cnts);
	end

	def accessoryInstall
		cnts = [];
		cnts << __rubyhead__;
		accessories = {'__optionProcess__': 'x'};
		libdir = File.join($toolHome,'lib');
		accessories.each_pair do |accessory,mode|
			puts "installing file: #{@home}/accessory/#{accessory}.rb";
			fh = File.open(libdir+"/#{accessory}.boot",'r');
			cnts = fh.readlines();
			cnts.each do |l|
				l.chomp!;
			end
			__writefile__(File.join(@home,"accessory/#{accessory}.rb"),cnts);
			__changemode__(File.join(@home,"accessory/#{accessory}.rb"),'x') if mode=='x';
		end
	end
	def __build__
		__builddir__(File.join(@home,'bin'));
		bootShellInstall;
		bootInstall;
		__builddir__(File.join(@home,'accessory'));
		accessoryInstall;
	end

end
