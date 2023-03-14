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
	# seqs[<instname>] = <seqinstance>
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
		@seqs[n.to_s] << si;
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
	
	def start(flow,*seqs)
		parallel = seqs.join(',');
		@starts[flow.to_s] = [] unless @starts.has_key?(flow.to_s);
		@starts[flow.to_s] << parallel;
	end

	# 1. arrange build_phase codes
	# 2. remove run_phase in pre-defined
	def finalize
		@methods['build_phase'].procedure(env.configCode.join("\n"));
		@methods.delete('run_phase');
		@starts.each_pair do |flowname,seqs|
			flowCodeArrangement(f,seqs);
		end
	end

	def flowCodeArrangement(f,seqs) ##{{{
		seqDeclaration(f,seqs);
		seqSetup(f,seqs);
		seqStart(f,seqs);
	end ##}}}

	def seqDeclaration(f,seqs) ##{{{
		codes = [];
		seqs.each do |sline|
			splitted = sline.split(',');
			splitted.each do |sn|
				next unless @seqs.has_key?(sn);
				s = @seqs[sn];
				codes << %Q|\t#{s.typename} #{s.instname};|;
			end
		end
		@methods[f.to_s].procedure(codes.join("\n"));
	end ##}}}
	def seqSetup(f,seqs) ##{{{
		codes=[];
		seqs.each do |sline|
			splitted = sline.split(',');
			splitted.each do |sn|
				next unless @seqs.has_key?(sn);
				s = @seqs[sn];
				csts = s.constraints;
				csts.map!{|item| "\t#{item}"};
				codes.append(*csts);
				codes << "\t#{s.instname}.randomize() with {";
				csts = s.randoms;
				csts.map!{|item| "\t\t#{item}"};
				codes.append(*csts);
				codes << "\t};";
			end
		end
		@methods[f.to_s].procedure(codes.join("\n"));
	end ##}}}
	def seqStart(f,seqs) ##{{{
		codes = [];
		seqs.each do |sline|
			splitted = sline.split(',');
			len = splitted.length;
			l = '';
			l += "\tfork\n" if len>1;
			splitted.each do |sn|
				next unless @seqs.has_key?(sn);
				s = @seqs[sn];
				l+= "\t" if len>1;
				l+= "\t#{s.instname}.start(#{s.seqr});"
			end
			l += "\tjoin" if len>1;
			codes << l;
		end
		@methods[f.to_s].procedure(codes.join("\n"));	
	end ##}}}

end