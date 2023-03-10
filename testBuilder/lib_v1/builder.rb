require 'debugger.rb'
require 'seq.rb'
require 'test.rb'
require 'testTemplate.rb'
module Builder

	attr_accessor :templates;
	attr_accessor :tests;
	attr_accessor :seqs;
	attr_accessor :rootpath;

	def self.setup(root)
		@templates = {};
		@tests = {};
		@seqs  = {};
		@rootpath = root;
		@debug = Debugger.new(true);
	end
	def self.find(n,t)
		message = "#{t}Finding".to_sym;
		return self.send(message,n);
	end
	def self.templateFinding(n)
		return nil unless @templates.has_key?(n);
		return @templates[n];
	end
	def self.testFinding(n)
		return nil unless @tests.has_key?(n);
		return @tests[n];
	end
	def self.createSeq(tn,bn,&block)
		s = Seq.new(tn,bn,@debug);
		s.instance_eval &block;
		setm = tn.to_sym;
		Test.define_method setm do |n,&block|
			#TODO, establish test.rb first
			self.prepareSeq(setm.to_s,n,block);
		end
		@seqs[tn] = s;
	end
	def self.createTest(tn,bn,&block)
		template = self.find(bn,:template);
		t=Test.new(tn,template,@debug);
		t.instance_eval &block;
		@tests[tn] = t; ## register to pool
	end
	def self.createTemplate(tn,&block)
		t = TestTemplate.new(tn,@debug);
		t.instance_eval &block;
		@templates[tn] = t;
	end
	def self.publish
		buildpath(@rootpath);
		@seqs.each_value do |s|
			s.publish(@rootpath);
		end
	end
end

def test(tn,bn,&block)
	tn=tn.to_s,bn=bn.to_s;
	Builder.createTest(tn,bn,block);
end

def seq(tn,bn,&block)
	tn=tn.to_s,bn=bn.to_s;
	Builder.createSeq(tn,bn,block);
end

def template(tn,&block)
	tn=tn.to_s;
	Builder.createTemplate(tn,block);
end