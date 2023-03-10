require 'svClass.rb'
# storing sequence instance information for the test
class SeqInst

	attr_accessor :typename;
	attr_accessor :instname;
	attr_accessor :constraints;
	attr_accessor :randoms;
	attr_accessor :seqr;

	attr :debug;

	def initialize(tn,n,d)
		# prepare a method for Test class so that a declared seq can be instantiated
		# by the Test.
		@typename = tn;
		@instname = n;
		@debug = d;
		@seqr = 'tbEnv.vseqr';
		@randoms = [];
		@constraints=[];
	end

	# provided to code block of the sequence instantiation method
	# constraints while in randomization
	def random(*codes)
		#TODO
		codes.each do |l|
			@randoms << "#{l};";
		end
	end
	# provided to code block of the sequence instantiation method
	# constraints directly called to enable/disable
	def constraint(n,s)
		n=n.to_s;v = 0;
		v = 1 if s==true;
		l = %Q|#{@instname}.#{n}.constraint_mode(#{v});|;
		@constraints << l;
	end

end

class Test < SVClass

	attr_accessor :base;
	# instantiated sequences
	# seqs[<flowname>] = <seqinstance>
	# current only support flow of :sim, this is a placeholder for later features
	attr_accessor :seqs;
	attr_accessor :env;
	attr_accessor :starts;

	def initialize(tn,b,d)
		@base = b;
		super(tn,b.classname,d);
		@seqs={};@starts={};
		@env = EnvInst.new();
		setupflow;
	end

	def setupflow
		@base.flows.each do |f|
			m = SVMethod.new(:task,f.name,f.args);
			m.qualifier= f.qualifier;
			@methods[f.name] = m;
		end
	end

	## env configurations feature ##{{{

	##}}}

	## prepare sequences feature ##{{{

	# sequence preparation by given instance name and block for constraint
	def prepareSeq(tn,n,&block)
		si = SeqInst.new(tn,n,@debug);
		si.instance_eval &block;
		@seqs[:test_sim] << si;
	end

	##}}}


	## publish call from Builder ##{{{

	def publish(path)
		codes = [];
		codes.append(*filemacro(@typename));
		codes.append(*declareClass(@typename,@base.typename));
		@methods.each_value do |m|
			codes.append(*m.code(:prototype));
		end
		codes.append(declareClassEnd);
		codes.append(filemacroend);
		@rootpath= path;
		buildfile(codes);
	end

	##}}}
	
	def start(*seqs)
		parallel = Array.new(*seqs);
		@starts << parallel;
	end

	# 1. arrange build_phase codes
	# 2. remove run_phase in pre-defined
	def finalize
		@methods['build_phase'].procedure(env.configCode.join("\n"));
		@methods.delete('run_phase');
		# arrange flow codes
		@seqs.each_pair do |flowname,seqs|
			flowname=flowname.to_s;
			flow = @methods[flowname];
			flowCodeArrangement(flow,seqs);
		end
	end

	def flowCodeArrangement(f,seqs)
		# sequence declaration
		codes = [];
		seqs.each do |s|
			codes << %Q|\t#{s.typename} #{s.instname};|;
		end
		f.procedure(codes.join("\n"));

		# sequence randomization and constraint setup
		codes=[];
		seqs.each do |s|
			csts = s.constraints;
			csts.map!{|item| "\t#{item}"};
			codes.append(*csts);
			codes << "\t#{s.instname}.randomize() with {";
			csts = s.randoms;
			csts.map!{|item| "\t\t#{item}"};
			codes.append(*csts);
			codes << "\t};";
		end
		f.procedure(codes.join("\n"));

		# sequence starting with from @starts
		codes = [];
		@starts.each do |p|
			len = p.length;
			l = '';
			l += "\tfork\n" if len>1;
			p.each do |s|
				l+= "\t" if len>1;
				l+= "\t#{s.instname}.start(#{s.seqr});"
			end
			l += "\tjoin" if len>1;
			codes << l;
		end
		f.procedure(codes.join("\n"));
	end

end