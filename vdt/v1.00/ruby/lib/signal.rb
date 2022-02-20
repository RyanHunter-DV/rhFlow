class DesignSignal ##{

	attr :name,:dir,:width;
	attr :container;

	def initialize name,dir,w ##{{{
		@name  = name;
		@dir   = dir;
		@width = w;
		@container = nil;
	end ##}}}


	def rtlName ##{{{
	end ##}}}

	def setContainer c ##{{{
		@container = c;
	end ##}}}

end ##}


def signal name,dir,w=1 ##{{{
	sig = DesignSignal.new(
		name.to_s,
		dir.to_s,
		w
	);

	self.addSignal sig;
end ##}}}
