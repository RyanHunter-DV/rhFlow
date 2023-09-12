require 'flows/StepBase'
require 'flows/NodeFlow'
#require 'flows/BuildFlow'

class DynamicLoader
	def initialize(ui,tc) ##{{{
		loadFlows(ui,tc);
	end ##}}}

	## run steps.
	def run() ##{{{
		noDl() if Rsim.steps.empty?;
		Rsim.steps.each do |step|
			if step.run() == Rsim::FAILED
				#TODO, exception processed later, will recode it.
				message = "#{step.name} failed";
				reason = step.reason;
				raise StepException.new(message,reason);
			end
		end
	end ##}}}
private
	# according to the steps in ui, to load builder, simulator regression manager etc.
	#
	def loadFlows(ui,tc) ##{{{
		ui.steps.each do |step|
			Rsim.mp.debug("loading step(#{step})");
			opts = ui.stepOpts[step];
			opts[:tconfig] = tc;opts[:ui]=ui;
			step = step.capitalize;
			require %Q|flows/#{step}Flow|;
			Rsim.mp.debug("create #{step}Flow with options:(#{opts})");
			Rsim.steps << eval("#{step}Flow.new(opts);");
		end
	end ##}}}
	def noDl() ##{{{
#TODO, detailed exception process shall be processed later.
		raise StepException.new('nostep',Rsim::FAILED);
	end ##}}}

end
