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
			puts "[DEBUG::LogicalSel]"
			puts "output: #{o};condition: #{c}"
			puts "---------------------------------"
		end #}
	end ##}}}

end ##}}}



def comSel name,args ##{{{
	s=LogicalSel.new(name.to_s);
	s.addSelPairs args;
	self.addLogics s;
end ##}}}

def seqSel name,opts ##{{{
	s=LogicalSel.new(name.to_s,true);
	if opts.has_key?(:clk)
		s.setClk opts[:clk];
	end
	if opts.has_key?(:rstn)
		s.setReset opts[:rstn],:pos;
	end
	if opts.has_key?(:rst)
		s.setReset opts[:rst],:neg;
	end
	conds = opts[:cond] || {};
	s.addSelPairs conds;
	self.addLogics s;
end ##}}}
