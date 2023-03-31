require 'exceptions.rb'
require 'builder.rb'
require 'options.rb'

#TODO
class MainEntry

	attr_accessor :debug;
	attr_accessor :options;

	attr :sig;
	def initialize
		@sig=0;
		begin
			@debug = Debugger.new(true);
			o= Options.new(@debug);
			@options = o.options;
		rescue RunException => e
			@sig = e.process;
		end
	end

	def run ##{{{
		return @sig if @sig!=0;
		begin
			Builder.setup(@options[:path]);
			Builder.loadSource(@options[:entry]);
			Builder.finalize;
			Builder.publish;
		rescue RunException => e
			@sig = e.process
		end
		return @sig;
	end ##}}}



end
