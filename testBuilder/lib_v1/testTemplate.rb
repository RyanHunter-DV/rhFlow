"""
setup a test template by calling the global 'template' command, which will call Builder.createTestTemplate.
And in test template object, this tool should realize the features for user configuration and publish the test base file.
### user configurations
*run(&block)*
This API allows users to setup the test flow for it, examples are: [[Features#define the running flow]].
*vtask(n,a='')*
defining a virtual task with empty body for the base test, those virtual tasks will be overridden by tests extended from it.
- n->name, name of the task
- a->args, args of the task
Examples: [[Features#virtual tasks defined for running flow]].
*env(tn)*
specify a env type name by which a env instantiation code will be placed at template's build_phase, and the instance name is fixed as 'tbEnv'.
Examples: [[Features#specify env type]].

### publishing
*publish(path)*
to organize the templates codes and building to a file through `@fop.buildfile`.
- path->the root path of this project, some tools may have extra local path in current class.
"""
require 'svClass.rb'
class TestTemplate < SVClass

	attr_accessor :flows;

	attr :userRunFlow;
	def initialize(tn,d)
		super(tn,:component,d);
		@basename = 'uvm_test';
		@flows=[];
		testloopSetup;
	end

	def testloopSetup ##{{{
		scalar('int','testloop','10');
	end ##}}}

	# vtask command, to setup flow for running
	def vtask(n,args='')
		n=n.to_s;
		task(n,args,'virtual');
		@flows << @methods[n];
	end

	# run command, which will process the returned code from block
	def run(&block)
		code = block.call;
		@userRunFlow = code;
		#@methods['run_phase'].procedure(code);
		return;
	end

	def finalize ##{{{
		finalizeSVClass;
		# setup run flow
		codes = [];
		codes << %Q|for (int loop=0;loop<testloop;loop++) begin|;
		codes.append(*@userRunFlow.split("\n")) if @userRunFlow;
		codes << 'end';
		codes.map!{|l| "\t"+l;};
		runf = @methods['run_phase'];
		runf.procedure(codes.join("\n"));
	end ##}}}
	def publish(path)
		codes = publishCode;
		buildfile(path,codes);
	end

end