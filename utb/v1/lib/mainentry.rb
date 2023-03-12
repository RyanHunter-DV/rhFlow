require 'debugger.rb'
require 'exceptions.rb'
require 'options.rb'
require 'builder.rb'

class MainEntry

	attr_accessor :debug;
	attr_accessor :options;

	attr :sig;
	def initialize
		@debug = Debugger.new(true);
		@sig=0;
		begin
			o = Options.new(@debug);
			@options = o.options;
		rescue RunException => e
			@sig = e.process;
		end
	end

	def run ##{{{
		return @sig if @sig!=0;
		begin
			Builder.setup(@options[:path],@debug);
			Builder.loadSource(@options[:entry]);
			Builder.finalize();
			Builder.publish();
		rescue RunException => e
			@sig = e.process;
		end
		return @sig;
	end ##}}}

end
