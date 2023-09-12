#require 'exceptions/RsimException'
class StepException < RsimException

	def initialize(step,reason) ##{{{
		super();
		@signal = 2; # step fail exit with signal 2
		@toExit = true;
		@stacks = caller(2);
		@message = "#{step} failed(#{reason}), Stacks:";
	end ##}}}
end
