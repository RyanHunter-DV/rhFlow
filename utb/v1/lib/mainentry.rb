require 'debugger.rb'
require 'exceptions.rb'
require 'options.rb'

class MainEntry

	attr_accessor :debug;
	attr_accessor :options;

	def initialize
		@debug = Debugger.new(true);
		o = Options.new();
		@options = o.options;
	end

	def run ##{{{
		sig = 0;
		begin
		rescue RunException => e
			sig = e.process
		end
		return sig;
	end ##}}}

end
