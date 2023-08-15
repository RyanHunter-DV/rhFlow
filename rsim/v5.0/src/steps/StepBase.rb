
class StepBase
	# the detailed string information of latest failure
	attr_accessor :reason;

	attr_accessor :name;

	# this is tool config for internal program config table,
	# differs from the IP-XACT's DesignConfig.
	attr_accessor :tconfig;
	attr_accessor :shell;

	## API: initialize(n), 
	def initialize(n,tc) ##{{{
		@reason='';@name='build';
		@tconfig = tc;@shell= CmdShell;
	end ##}}}

end
