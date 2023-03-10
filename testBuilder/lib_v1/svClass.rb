require 'svSyntax.rb'
require 'svMethod.rb'
require 'svField.rb'

class SVClass
	attr_accessor :sv;

	attr_accessor :classname;
	attr_accessor :basename;
	attr_accessor :debug;

	attr_accessor :methods;
	attr_accessor :fields;

	def initialize(cn,bn,d,uvmct = :component)
		@classname = cn;
		@basename  = bn;
		@debug = d;
		@sv = SVSyntax.new();
		@methods={};@fields={};
		builtins(uvmct);
	end

	def constructor(ct)
		a = %Q|string name = "#{@classname}"|;
		a+= %Q|,uvm_component parent=null| if ct==:component;
		m = SVMethod.new(:func,'new',a,'');
		@methods['new'] = m;
	end

	def phases()
		phase('build',:func);
		phase('connect',:func);
		phase('run',:task);
	end

	def phase(n,t)
		mn = "#{n}_phase";
		m = SVMethod.new(t,n,'uvm_phase phase');
		m.qualifier= 'virtual';
		m.procedure("super.#{mn}(phase);");
		@methods[mn] = m;
	end

	def builtins(ct)
		constructor(ct);
		phases() if ct==:component;
	end

end