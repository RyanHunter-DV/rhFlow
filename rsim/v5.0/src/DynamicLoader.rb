require 'steps/StepBase'
require 'steps/build'
require 'steps/rhload'
class DynamicLoader
	def initialize(ui,tc) ##{{{
		loadSteps(ui,tc);
	end ##}}}

	## run steps.
	def run() ##{{{
		noDl() if Rsim.steps.empty?;
		Rsim.steps.each do |step|
			if step.run() == Rsim::FAILED
				message = "#{step.name} failed";
				reason = step.reason;
				raise StepException.new(message,reason);
			end
		end
	end ##}}}
private
	# according to the steps in ui, to load builder, simulator regrmanager etc.
	#
	def loadSteps(ui,tc) ##{{{
		ui.steps.each do |step|
			Rsim.mp.debug("loading step(#{step})");
			opts = ui.stepOpts[step];
			opts[:tconfig] = tc;
			step = step.capitalize;
			require %Q|steps/#{step}Flow|;
			Rsim.steps << eval("#{step}Flow.new(#{opts});");
		end
	end ##}}}
	def noDl() ##{{{
		raise StepException.new('nostep',Rsim::FAILED);
	end ##}}}

end
