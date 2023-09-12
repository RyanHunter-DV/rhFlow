require 'DynamicLoader';
require 'ToolConfig';

class Core

	## tool config table setup by other differnt components.
	attr :tconfig;

	def initialize(ui,tc) ##{{{
		runner = setup(ui,tc);
		run(runner);
	end ##}}}
	
private
	## load required steps according to the ui
	def setup(ui,tc) ##{{{
		#directly called by loader, ui.processSteps();
		runner = DynamicLoader.new(ui,tc);
		return runner;
	end ##}}}
	## run steps
	def run(runner) ##{{{
		# run scheduled steps according from the loader setup.
		runner.run();
	end ##}}}

end
