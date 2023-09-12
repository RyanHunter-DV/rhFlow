"""
# Object description:
UserException, used to build user exceptions
"""
#require 'exceptions/RsimException'
class UserException < RsimException ##{{{
	def initialize(reason) ##{{{
		super();
		@signal = 2; # step fail exit with signal 2
		@toExit = true;
		@stacks = caller(2);
		@message = "User operation failed(#{reason}), Stacks:";
	end ##}}}

end ##}}}