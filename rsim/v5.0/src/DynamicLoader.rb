class DynamicLoader
	def initialize(ui) ##{{{
		loadSteps(ui);
	end ##}}}

	## run steps.
	def run() ##{{{
		noDl() if Rsim.steps.empty?;
		Rsim.steps.each do |step|
			if step.run() == Rsim::FAILED
				raise StepException.new(step,Rsim::FAILED);
			end
		end
	end ##}}}
private
	# according to the steps in ui, to load builder, simulator regrmanager etc.
	#
	def loadSteps(ui) ##{{{
		ui.steps.each do |step|
			Rsim.mp.debug("loading step(#{step})");
			opts = ui.stepOpts[step];
			require %Q|steps/#{step}|;
			Rsim.steps << eval("#{step.capitalize}.new(#{opts});");
		end
	end ##}}}
	def noDl() ##{{{
		raise StepException.new('nostep',Rsim::FAILED);
	end ##}}}

end
