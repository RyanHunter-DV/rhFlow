require 'clock.rb'
require 'reset.rb'
require 'dut.rb'
require 'vip.rb'
require 'fileOperator.rb'
require 'codeGenerator.rb'

class Top

	attr :debug;
	attr :filename;

	attr_accessor :clock;
	attr_accessor :reset;
	attr_accessor :duts;
	attr_accessor :vips;

	def initialize(d) ##{{{
		@debug = d;
		@duts  = {};
		@vips  = {}; # vip instances
		@filename='top.sv';
		@clock = Clock.new(@debug);
		@reset = Reset.new(@debug)
	end ##}}}

	def createVipInstance(b,iname,ifname,ifport) ##{{{
		vi = VipInst.new(iname,b,@debug);
		vi.interfaceInst(ifname,ifport);
		@vips[iname] = vi;
	end ##}}}

	def clock(n,freq) ##{{{
		@clock.setup(n,freq);
		setm = n.to_sym;
		self.define_singleton_method setm do
			return @clock.signal(n);
		end
	end ##}}}

	def reset(n,active,init) ##{{{
		@reset.setup(n,active,init);
		setm = n.to_sym;
		self.define_singleton_method setm do
			return @reset.signal(n);
		end
	end ##}}}

	def dut(mname,iname,&block) ##{{{
		d = Dut.new(mname,iname,@debug);
		d.top= self;
		d.instance_eval &block;
		@duts[iname] = d;
	end ##}}}

	def buildCode(t,cg) ##{{{
		t=t.to_s;
		m = "build#{t.capitalize}Code";
		codes = self.send(m,cg);
		codes.map!{|l| "\t"+l;};
		return codes;
	end ##}}}

	def buildClockCode(cg) ##{{{
		codes=[];
		tname = @clock.interface;
		iname = @clock.interfaceInst;
		ports = @clock.interfacePorts;
		codes<<cg.interfaceInst(tname,iname,ports);
		codes<<'initial begin';
		codes<< "\t"+cg.configset("virtual #{tname}",'null','uvm_test_top.tbEnv.clock',"top.#{iname}",iname);
		codes<<'end';
	end ##}}}
	def buildResetCode(cg) ##{{{
		codes=[];
		tname = @reset.interface;
		iname = @reset.interfaceInst;
		ports = @reset.interfacePorts;
		codes<<cg.interfaceInst(tname,iname,ports);
		codes<<'initial begin';
		codes<< "\t"+cg.configset("virtual #{tname}",'null','uvm_test_top.tbEnv.reset',"top.#{iname}",iname);
		codes<<'end';
	end ##}}}
	# in top.sv, vip codes are interface declaration and configuration codes
	def buildVipsCode(cg) ##{{{
		return [] if @vips.empty?;
		codes = [];
		configCodes=['initial begin'];
		@vips.each_value do |vi|
			tname = vi.interfaceType;
			iname = vi.interfaceInst;
			ports = vi.interfacePorts;
			codes << cg.interfaceInst(tname,iname,ports);
			vhier = vi.fullHierarchy;
			# config: type, first hier, second hier, name, field
			configCodes << "\t"+cg.configset("virtual #{tname}",'null',"#{vhier}","top.#{iname}",iname);
		end
		configCodes << 'end';
		codes.append(*configCodes);
		return codes;
	end ##}}}
	def buildDutCode(cg) ##{{{
		codes=[];
		@duts.each_value do |d|
			codes.append(*cg.moduleInstance(d));
		end
		return codes;
	end ##}}}



	def arrangeCodes ##{{{
		cg = CodeGenerator.new(@debug);
		codes=[];
		codes.append(*cg.filemacro(@filename));
		codes.append(*cg.declareModule('Top'));

		codes.append(*buildCode(:clock,cg));
		codes.append(*buildCode(:reset,cg));
		codes.append(*buildCode(:vips,cg));
		codes.append(*buildCode(:dut,cg));


		codes.append(*cg.declareModuleEnd);
		codes.append(*cg.filemacroEnd);
		return codes;
	end ##}}}

	def publish(rootpath) ##{{{
		path = File.join(rootpath,'tb');
		# fop = FileOperator.new(path,@filename,@debug); # TODO
		contents = arrangeCodes;
		puts contents;
	end ##}}}
end
