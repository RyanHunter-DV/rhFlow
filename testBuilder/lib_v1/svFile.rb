require 'fileOperator.rb'
class SVFile
	attr_accessor :filename;
	attr_accessor :rootpath;

	attr :debug;
	attr :fop;

	# tn->typename, or classname
	def initialize(tn,d,ext='.svh')
		@rootpath = '';
		@filename = tn;@filename[0..0].downcase!;
		@filename += ext;
		@debug =d;
		@fop = FileOperator.new();
	end

	# return head macro like:
	# `ifndef filename__svh
	# `define filename__svh
	def filemacro(fn)
		m = fn.sub(/\./,'__');
		cnts = [];
		cnts << '`ifndef '+m;
		cnts << '`define '+m;
		return cnts;
	end
	def filemacroend
		return ["\n`endif"]
	end

	def buildfile(cnts)
		@debug.print("buildfile: #{File.join(@rootpath,@filename)}");
		@fop.buildfile(@rootpath,@filename,cnts);
	end

end
