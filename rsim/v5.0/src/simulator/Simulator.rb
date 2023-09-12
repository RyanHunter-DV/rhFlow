"""
"""
require 'simulator/SimulatorStep'
class Simulator

	## attr :filelist;

	# tools of simulator, which is an object that supports apis like: option
	attr_accessor :compile;
	attr_accessor :elab;
	attr_accessor :run;

	attr :name;

	## API: initialize, 
	def initialize(n) ##{{{
		@name = n;
		@elab = SimulatorStep.new(:elab);
		@run  = SimulatorStep.new(:run);
		@compile = SimulatorStep.new(:compile);
	end ##}}}
end

