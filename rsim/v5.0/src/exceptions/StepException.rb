class StepException < RsimException

	def initialize(step,status) ##{{{
		super();
		@exitstatus = status;
		@stacks = caller(2);
		@message= "#{step} failed, Stack:";
	end ##}}}
	
end
