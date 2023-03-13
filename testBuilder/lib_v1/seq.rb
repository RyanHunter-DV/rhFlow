# by using this can declare a sequence object which stores and has ability to build
# a sequence file
# key features of this object:
# - setup user configurations;
# - publish sequence;
require 'svClass.rb'
class Seq < SVClass
	attr_accessor :pseqr;
	def initialize(cn,bn,d)
		super(cn,bn,d,:object);
		@pseqr = '';
		setupbody;
	end

	# user called method to define a random field of this seq
	def rand(t,v)
		t=t.to_s; v=v.to_s;
		f = SVField.new(:scalar,t,v);
		f.qualifier= 'rand';
		@fields[v] = f;
	end
	# executed by seq declaration, 
	# get execution code for body customized by users.
	def body &block
		code = block.call;
		@methods['body'].procedure(code);
		return;
	end

	def setupbody
		m = SVMethod.new(:task,'body','');
		m.qualifier= 'virtual';
		@methods['body'] = m;
		return;
	end

	def publish(path)
		cnts = [];
		cnts.append(*filemacro);
		cnts.append(*code(:declareClass)); #TODO
		@fields.each_value do |f|
			cnts << "\t"+f.code(:instance);
		end
		# util
		cnts << %Q|\t`uvm_object_utils_begin(#{@classname})|;
		@fields.each_value do |f|
			cnts << "\t"+f.code(:utils);
		end
		cnts << %Q|\t`uvm_object_utils_end|;
		cnts << "\t`uvm_declare_p_sequencer(#{@pseqr})" if @pseqr;
		@methods.each_value do |m|
			cnts << "\t"+m.code(:prototype);
		end
		cnts.append(*code(:declareEnd));

		# building body code
		@methods.each_value do |m|
			cnts.append(*m.code(:body));
		end
		cnts.append(*filemacroend);
		@rootpath= path;
		buildfile(cnts);
	end

	def finalize
	end
end