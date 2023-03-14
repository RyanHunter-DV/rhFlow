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
		codes = [];
		#TODO
	end

end