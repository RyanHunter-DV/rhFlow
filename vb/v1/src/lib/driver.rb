require 'codeGenerator.rb'

class Driver
	attr_accessor :classname;
	attr_accessor :basename;
	attr_accessor :fields;
	attr_accessor :methods;

	attr :debug;
	attr :path; # extra path for this driver
	attr :params;
	attr :tparams;

	def initialize(proj,ext,d) ##{{{
		@debug = d;@path  = './';
		@classname = "#{proj}#{ext.capitalize}Driver";
		@basename = 'uvm_driver#(REQ,RSP)';
		@params=[];@tparams=[];
		@fields=[];@methods=[];
	end ##}}}

	# set extra path for this driver
	def path(p) ##{{{
		@path = p;
	end ##}}}

	def base(bn) ##{{{
		@basename = bn;
	end ##}}}

	def param(*args) ##{{{
		@params.append(*args);
	end ##}}}
	def tparam(*args) ##{{{
		@tparams.append(*args);
	end ##}}}

	# fields commands {

	# format:
	# field :scalar, 'int', 'ia'
	def field(t,*args) ##{{{
		f = SVField.new(t,*args);
		@fields << f;
	end ##}}}

	# format:
	# task 'name','args'
	def task(n,a,q='',&block) ##{{{
		m = SVMethod.new(:task,n,a,@debug);
		m.qualifier= q if q!='';
		code = block.call;
		m.procedure(code);
		@methods << m;
	end ##}}}

	# }

	def publish(root) ##{{{
		codes = [];
		cg = CodeGenerator.new(@debug);
		codes.append(*cg.filemacro(@classname));
	end ##}}}
end