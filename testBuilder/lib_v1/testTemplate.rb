require 'svClass.rb'
class TestTemplate < SVClass

	attr_accessor :flows;

	def initialize(tn,d)
		super(tn,'uvm_test',d)
		@flows=[];
	end

	# vtask command, to setup flow for running
	def vtask(n,args='')
		n=n.to_s;
		m = SVMethod.new(:task,n,args);
		m.qualifier= 'virtual';
		@methods[n] = m;
		@flows << m;
	end

	# run command, which will process the returned code from block
	def run(&block)
		code = block.call;
		@methods['run_phase'].procedure(code);
		return;
	end

	def publish(path)
	end

end