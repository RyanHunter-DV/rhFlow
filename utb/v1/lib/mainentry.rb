require 'debugger.rb'
require 'exceptions.rb'
require 'options.rb'
require 'builder.rb'

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
			Builder.setup(@options[:path],@debug);
			Builder.loadSource(@options[:entry]);
			Builder.finalize();
			Builder.publish();
		rescue RunException => e
			sig = e.process
		end
		return sig;
	end ##}}}

end
