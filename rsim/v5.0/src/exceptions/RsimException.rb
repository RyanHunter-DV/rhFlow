"""
# Object description:
exceptions will be raised with some certain stacks if necessary, verbosity of the exceptions can be:
:warning, :error, :fatal, users can raise an exception by:
`raise <ExceptionType>.new('reason message')`
"""
class RsimException < Exception
	attr_accessor :signal;
	attr_accessor :stacks;

	attr :message;
	attr :toExit;
	def initialize() ##{{{
		@signal=0; @stacks=[]; @message='';
		@toExit=true; # by default is true
	end ##}}}

	def process() ##{{{
		Rsim.mp.error(@message,:pos=>caller(1)[0]);
		reportStacks() unless @stacks.empty?;
		exit @signal if exit?;
	end ##}}}

	def reportStacks() ##{{{
		@stacks.each do |s|
			Rsim.mp.error(s,:pos=>false);
		end
	end ##}}}

	def exit?
		return @toExit;
	end

end