require 'DynamicLoader';
class Core
	def initialize(ui) ##{{{
		step = setup(ui);
		run(step);
	end ##}}}
	
	## load required steps according to the ui
	def setup(ui) ##{{{
		#directly called by loader, ui.processSteps();
		step = DynamicLoader.new(ui);
		return step;
	end ##}}}
	## run steps
	def run(step) ##{{{
		# run scheduled steps according from the loader setup.
		step.run();
	end ##}}}
end
