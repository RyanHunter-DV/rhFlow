require 'codeGenerator.rb'

class Driver < SVClass

	attr :path; # extra path for this driver

	def initialize(proj,ext,d) ##{{{
		@path  = './';
		cn = "#{proj}#{ext.capitalize}Driver";
		super(cn,d);
		@basename = 'uvm_driver#(REQ,RSP)';
	end ##}}}

	# set extra path for this driver
	def path(p) ##{{{
		@path = p;
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

		codes.append(*cg.filemacro(@filename));
		codes.append(*cg.declareClass(@classname,@tparams.join(','),@params.join(','),@basename));

		# MARK

		codes.append(*cg.declareClassEnd);
		codes.append(*cg.filemacroEnd);

		puts "test for publish driver";
		puts codes;
	end ##}}}
end
