rhload 'plugin/buildflow.rb'
rhload 'plugin/simulatorbase.rb'

class Xcelium < SimulatorBase ##{{{

	def __setupOptionFormats__ ##{{{
		@optformat[:incdir] = '-incdir ';
	end ##}}}
    def initialize ctx,d ##{{{
		super(:xlm,ctx,d);
		__setupOptionFormats__;
    end ##}}}

	def __builtinCompCmd__ ##{{{
		cmds = [];
		cmds << 'xmvlog';
		cmds << '-64BIT';
		cmds << '-SV';
		cmds << "-LOGFILE #{@logfile[:comp]}";
		return cmds;
	end ##}}}
end ##}}}
