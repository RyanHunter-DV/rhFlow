class Reset
	attr :debug;

	attr :index;
	attr :ifType;
	attr :ifInst;
	attr :signal;
	attr :map;
	def initialize(d) ##{{{
		@debug = d;
		@ifType = 'ResetGenIf';
		@ifInst = 'tbRstn';
		@signal = 'oResetn'
		@map = {};
		@index = 0;
	end ##}}}

	def setup(n,active,init) ##{{{
		info = {:signal=>"#{@signal}[#{@index}]",:active=>active.to_i,:init=>init};
		@index+=1;
		map[n.to_s] = info;
	end ##}}}

	# according to clock name in ruby view, return the signal name in SV view
	def signal(n) ##{{{
		return '' unless map.has_key?(n);
		return map[n][:signal];
	end ##}}}
	def interface ##{{{
		return @ifType;
	end ##}}}
	def interfaceInst ##{{{
		return @ifInst;
	end ##}}}
	def interfacePorts ##{{{
		return 'tbClk'; #TODO
	end ##}}}
end