require 'simulator/Simulator'

class Xcelium < Simulator

	## API: initialize, 
	def initialize(opts) ##{{{
		super(:xcelium);
		targets = ['compiler','elaborator','runner'];
		targets.each do |t|
			self.send("setup#{t.capitalize}".to_sym,opts);
		end
	end ##}}}

public

private

	## setupCompiler, this api to setup the compile tool with a bunch of apis calling the
	# base CompileTool.
	def setupCompiler(opts); ##{{{
		raise RsimException.new("no filelist specified in building Simulator") unless opts.has_key?(:filelist);
		# add base command for compile tool;
		@compile.base 'xmvlog'; 
		# add default options
		@compile.option.add '-sv','-64bit';
		@compile.option.add "-f #{opts[:filelist]}"
		@compile.option.format('incdir','-incdir ');
		@compile.option.format('filelist','-f ');
		#puts "#{__FILE__}:(setupCompiler) is not ready yet."
	end ##}}}

	## setupElaborator(opts), setup elaborator for xcelium
	def setupElaborator(opts); ##{{{
		@elab.base 'xmelab';
		#TODO, more default options required
		puts "#{__FILE__}:(setupElaborator(opts)) is not ready yet."
	end ##}}}

	## setupRunner(opts), to setup run command and options
	def setupRunner(opts); ##{{{
		@run.base 'xmsim';
		puts "#{__FILE__}:(setupRunner(opts)) is not ready yet."
	end ##}}}
end