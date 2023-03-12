require 'debugger.rb'
require 'exceptions.rb'
require 'options.rb'
require 'builder.rb'


class MainEntry

	attr_accessor :debug;
	attr_accessor :options;

	attr :sig;

	def initialize ##{{{
		@sig = 0;
		begin
			@debug = Debugger.new(true);
			o = Options.new(@debug);
			@options = o.options;
		rescue RunException => e
			@sig = e.process;
		end
	end ##}}}

	def run ##{{{
		begin
			Builder.setup(@options[:path],@debug);
			Builder.loadSource(@options[:entry]);
			Builder.finalize;
			Builder.publish;
		rescue RunException => e
			@sig = e.process;
		end
		return @sig;
	end ##}}}

end
