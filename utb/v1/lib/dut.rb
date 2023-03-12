class Dut
	attr_accessor :name;
	attr_accessor :instname;
	attr_accessor :top;
	attr_accessor :connections;
	attr_accessor :portnum;

	attr :debug;
	def initialize(mn,mi,d) ##{{{
		@name=mn;@instname=mi;
		@debug = d;
		@connections={};
		@portnum=0;
	end ##}}}

	def connect(**pairs) ##{{{
		pairs.each_pair do |o,t|
			@connections[o]=t;
			@portnum+=1;
		end
	end ##}}}
end
