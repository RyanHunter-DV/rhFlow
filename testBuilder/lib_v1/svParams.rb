class SVParams

	attr :type; #:tparam or :param
	attr :debug;

	attr :pairs;

	def initialize(t,d) ##{{{
		@type = t.to_sym;
		@debug= d;
		@pairs={};
	end ##}}}

	def add(p) ##{{{
		splitted = p.split('=');
		raise RunException.new("invalid param pair(#{p})",3) if splitted.length <= 1;
		@pairs[splitted[0]] = splitted[1];
		return;
	end ##}}}
	# return array of param pairs: ['pa=v','pc=v']
	def pairs ##{{{
		rtns=[];
		@pairs.each_pair do |p,v|
			rtns << "#{p}=#{v}";
		end
		return rtns;
	end ##}}}
	# return array of param types
	def params ##{{{
		return @pairs.keys;
	end ##}}}
end