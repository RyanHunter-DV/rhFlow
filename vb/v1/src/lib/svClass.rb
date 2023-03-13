class SVClass
	attr_accessor :classname;
	attr_accessor :basename;
	attr_accessor :filename;
	attr_accessor :fields;
	attr_accessor :methods;
	attr_accessor :params;
	attr_accessor :tparams;

	attr :debug;

	def initialize(cn,d) ##{{{
		@debug = d;
		@classname = cn;
		@filename = @classname+'.svh';@filename[0..0].downcase!;
		@params=[];@tparams=[];
		@fields=[];@methods=[];
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

	# format:
	# func 'name','args','rtn'
	def func(n,a,r,q='',&block) ##{{{
		m = SVMethod.new(:func,n,a,@debug);
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

		puts "test for publish #{@classname}";
		puts codes;
	end ##}}}
end