#! /usr/bin/env ruby

## this file is required by djMain/bin/rh


## 1.loading kernel modules
## 2.loading prerequisites
require 'rhOptions'
## TODO require 'rhPlugin'

## TODO,
=begin
require 'rhReporter'
require 'rhLoad'

=end

## 3.loading standard flow files


## 4.loading project specific files








module RhMain ## {

	def self.mainApp;@mainApplication ||= ApplicationClass.new();end

	## singleton
	def self.run;mainApp.run;end
	def self.options; mainApp.getOptionHandle; end



end ## }

class RhMain::ApplicationClass ## {

	## use to detect this class will only instantiated once
	@@staticInstance = nil
	@optionHandle = nil

	## actions processed in this function:
	## 1.parse user options
	## 2.setup reporter
	## 3.setup db
	def initialize ## {
		if @@staticInstance; return @@staticInstance; end

		parseOptions
		init_reporter
		init_db
		
		@@staticInstance = self
		self
	end ## }

	def parseOptions ## {
		if @optionHandle == nil; @optionHandle = RhOptionsClass.new();end
		@optionHandle.parseOptions
	end ## }

	def init_reporter ## {
		## TODO
	end ## }

	def init_db ## {
		## TODO
	end ## }

	## process to do here
	## 1.loading standard flow files, by $ENV['RH_PLUGINS'], or by option -p
	## 2.loading project specific files by $PROJECT_HOME/node.rh
	## other steps
	def run ## {

		## TODO, rhMultLoad RhPlugin.getPlugins

		## TODO, load buildflow_standard, testing standard flow
		$: << '/home/huangqi/prj/GitHub/rhFlow/metaFlowVersion/rhBuild_standard'
		load 'node.rh'

		## test file
		$: << './'
		load 'project_node.rh'
		

	end ## }

	def getOptionHandle ## {
		return @optionHandle
	end ## }

end ## }

