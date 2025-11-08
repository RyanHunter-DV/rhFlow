class Vip
	attr :debug;

	attr :interfaceTypeName;
	def initialize(d) ##{{{
		@debug = d;
	end ##}}}

	def interface(n=nil) ##{{{
		return @interfaceTypeName unless n;
		@interfaceTypeName = n.to_s;
	end ##}}}
end

class VipInst

	attr_accessor :base;
	attr_accessor :name;
	attr_accessor :interfacePorts;

	attr :debug;
	attr :interfaceInstName;

	def initialize(iname,b,d) ##{{{
		@name = iname;
		@base = b;
		@debug= d;
	end ##}}}

	def interfaceInst(*args) ##{{{
		return @interfaceInstName if args.empty?;
		ifinst=args[0];ifport=args[1];
		@interfaceInstName = ifinst;
		@interfacePorts = ifport;
	end ##}}}
	def fullHierarchy ##{{{
		return "uvm_test_top.tbEnv.UnitEnv.#{name}";
	end ##}}}

	def interfaceType ##{{{
		return @base.interface;
	end ##}}}

end