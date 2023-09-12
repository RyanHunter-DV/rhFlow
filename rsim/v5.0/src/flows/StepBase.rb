require 'libs/cmdshell'
class StepBase
	# the detailed string information of latest failure
	attr_accessor :reason;

	attr_accessor :name;

	# this is tool config for internal program config table,
	# differs from the IP-XACT's DesignConfig.
	attr_accessor :tconfig;
	attr_accessor :shell;
	attr_accessor :ui;

	## API: initialize(n), 
	def initialize(n,tc,ui) ##{{{
		@reason='';@name='build';
		@tconfig=tc;@shell=Shell;@ui=ui;
	end ##}}}

end
