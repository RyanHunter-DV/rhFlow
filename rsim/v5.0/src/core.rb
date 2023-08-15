require 'DynamicLoader';
class Core

	## tool config table setup by other differnt components.
	attr :tconfig;

	def initialize(ui) ##{{{
		step = setup(ui);
		run(step);
	end ##}}}
	
private
	## load required steps according to the ui
	def setup(ui) ##{{{
		@tconfig = initToolConfig(ui);
		#directly called by loader, ui.processSteps();
		step = DynamicLoader.new(ui,@tconfig);
		return step;
	end ##}}}
	def initToolConfig(ui) ##{{{
#TODO, require tc class.
		tc = ToolConfig.new(ui);
		return tc;
	end ##}}}
	## run steps
	def run(step) ##{{{
		# run scheduled steps according from the loader setup.
		step.run();
	end ##}}}

end
