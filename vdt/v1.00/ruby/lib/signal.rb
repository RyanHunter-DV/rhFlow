class DesignSignal ##{

	attr :name,:dir,:width;

	def initialize name,dir,w ##{{{
		@name  = name;
		@dir   = dir;
		@width = w;
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
