class DesignSignal ##{

	attr :name,:dir,:width;
	attr :container;
	## if a signal is connected in a specific instance, then the
	## originator[<instanceName>] is the target of the connect
	attr :connections;
	attr :rtlname;

	def initialize name,dir,w ##{{{
		@name  = name.to_s;
		@dir   = dir.to_s;
		@width = w;
		@container = nil;
		@connections = Hash.new();
		@rtlname = Hash.new();
	end ##}}}

	## call this to return the target signal of @currentInst
	def originator ##{{{
		fullS = @container.currentInst+'.'+@name;
		return @connections[fullS] if @connections.has_key?(fullS);
		puts "Error, no originator found for #{fullS}"
		return nil;
	end ##}}}


	def setRtlname inst,n ##{{{
		@rtlname[inst] = n;
	end ##}}}

	def rtlname
		return @rtlname[@container.currentInst];
	end

	def setContainer c ##{{{
		@container = c;
	end ##}}}

	def connect inst,target ##{{{
		s = inst.to_s+'.'+@name;
		@connections[s] = target;
		if @container.is_a?(DesignComponent)
			setRtlname inst, target.name;
		end
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
