require 'MessagePrinter';
require 'RsimExceptions';
require 'UserInterface';
require 'Core';

module Rsim

	FAILED = 1;
	SUCCESS= 0;

	@mp   =nil;
	@steps=nil;

	def self.mp() ##{{{
		return @mp;
	end ##}}}
	def self.steps() ##{{{
		return @steps;
	end ##}}}
	def self.init () ##{{{
		@mp = MessagePrinter.new('Rsim',:debug);
		@steps=[];
	end ##}}}
	## start the core of Rsim tool, to process major steps.
	def self.start () ##{{{
		self.init();
		begin
			ui = UserInterface.new();
			core = Core.new(ui);
		rescue RsimException => e
			e.process();
			return e.exitstatus if (e.exit?);
			#TODO, may be extra process here.
		end
		return 0;
	end ##}}}
	
end
