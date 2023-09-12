"""
# Object description:
SimulatorStep, the compiler object called by the tool to add base commands, options
and can also generate the commands by build a command file.
- base: setup base executing command.
- options: SimulatorOption object, stores different options
This object stands for compile, elab, run steps
"""
require 'base/ToolOption'

class SimulatorStep ##{{{

	attr_accessor :option;

	attr :base;
	attr :name;

	## initialize, constructor
	def initialize(n); ##{{{
		@base=''; @name=n.to_s; # step name
		@option=ToolOption.new();
		#puts "#{__FILE__}:(initialize) is not ready yet."
	end ##}}}

	## base(v), add base executing command
	def base(v); ##{{{
		@base = v;
		#puts "#{__FILE__}:(base(v)) is not ready yet."
	end ##}}}
	
end ##}}}