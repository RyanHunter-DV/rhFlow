require 'lib/rtl'
class DesignLogicalBase; ##{
	attr :name;
	attr :reset;
	attr :clk;
	attr :isSeq;

	def initialize name,seq ##{{{
		@name = name;
		@reset = Hash.new();
		@clk = nil;
		@isSeq = seq;
	end ##}}}

	def setReset s,edge ##{{{
		@reset['name'] = s;
		@reset['edge'] = edge.to_s;
	end ##}}}

	def setClk c ##{{{
		@clk = c;
	end ##}}}

	def publish ##{{{
	end ##}}}

	## TBD,
	def logicType ##{{{
		return 'sequential' if @isSeq;
		return 'combinational';
	end ##}}}
end ##}


class LogicalSel < DesignLogicalBase; ##{{{
	## selPairs
	## <result>=><condition>
	## "o=1'b1"=>"s[0]==1'b1"
	attr :selPairs;

	def initialize name,seq ##{{{
		super(name,seq);
		@selPairs = Hash.new();
	end ##}}}

	def addSelPairs args; ##{{{
		args.each_pair do #{
			|o,c|
			@selPairs[o] = c;
		end #}
	end ##}}}

	## generated a verilog rtl and return the contents
	def publish
		cnts = Array.new();
		if @isSeq
			cnts = RTL.sequentialSelLogic(
				@clk,
				@reset,
				@selPairs
			);
		else
		end

		## return contents to caller
		return cnts;
	end

end ##}}}

def comSel name,args ##{{{
	s=LogicalSel.new(name.to_s);
	s.addSelPairs args;
	if self.is_a?(DesignComponent)
		self.addLogics s, self.currentInst;
	else
		self.addLogics s;
	end
end ##}}}

def seqSel name,opts ##{{{
	s=LogicalSel.new(name.to_s,true);
	if opts.has_key?(:clk)
		s.setClk opts[:clk];
	end
	if opts.has_key?(:rstn)
		s.setReset opts[:rstn],:negedge;
	end
	if opts.has_key?(:rst)
		s.setReset opts[:rst],:posedge;
	end
	conds = opts[:cond] || {};
	s.addSelPairs conds;
	puts "adding logic: #{s.object_id} of component: #{self.object_id}"
	if self.is_a?(DesignComponent)
		self.addLogics s, self.currentInst;
	else
		self.addLogics s;
	end
end ##}}}
