class RsimException < Exception
	attr_accessor :exitstatus
	attr_accessor :stacks;

	attr :message;
	def initialize() ##{{{
		@exitstatus=0;
		@stacks=[];
	end ##}}}

	def process() ##{{{
		Rsim.mp.error(@message,:pos=>caller(1)[0]);
		reportStacks() unless @stacks.empty?;
	end ##}}}

	def reportStacks() ##{{{
		@stacks.each do |s|
			Rsim.mp.error(s,:pos=>false);
		end
	end ##}}}
	
end



require 'exceptions/StepException'
