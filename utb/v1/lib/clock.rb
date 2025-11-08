
class Clock
	attr :debug;

	attr :clockIndex;
	attr :ifType;
	attr :ifInst;
	attr :signal;
	attr :map;
	def initialize(d) ##{{{
		@debug = d;
		@ifType = 'ClockGenIf';
		@ifInst = 'tbClk';
		@signal = 'oClk'
		@map = {};
		@clockIndex = 0;
	end ##}}}

	def setup(n,freq) ##{{{
		info = {:signal=>"#{@signal}[#{@clockIndex}]",:freq=>freq};
		@clockIndex+=1;
		map[n.to_s] = info;
	end ##}}}

	# according to clock name in ruby view, return the signal name in SV view
	def signal(n) ##{{{
		n=n.to_s;
		@debug.print("finding signal(#{n})");
		return '' unless map.has_key?(n);
		return %Q|#{@ifInst}.#{map[n][:signal]}|;
	end ##}}}
	def interface ##{{{
		return @ifType;
	end ##}}}
	def interfaceInst ##{{{
		return @ifInst;
	end ##}}}
	def interfacePorts ##{{{
		return '';
	end ##}}}
end
