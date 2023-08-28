require 'ipxact/IpxactBase'
require 'ipxact/Component'
require 'ipxact/Design'
require 'ipxact/DesignConfig'

require 'libs/rhload' # load global rhload api

require 'MetaData'; # the database where all ip-xact data located.
class NodeFlow

	def initialize(ui) ##{{{
#TODO, setup required options from ui, which also has a tool
# configs.

		#TODO, require root in ui, which being used for nodeflow as the entry node.
		@entry = ui.root;
	end ##}}}

	def run(runner) ##{{{
#TODO, requires db api in runner, which will be used to store the global
# meta-data which will be loaded by this flow.
		runner.db = MetaData.new();
#TODO, require UiException, which process all user input options issues.
		raise UiException.new("required root entry not specified") unless @entry;
#TODO, require global var: $mp, which defined at core, for global MessagePrinter
		$mp.debug("loading entry node:(#{@entry})");
		rhload @entry;
	end ##}}}

public

private
	
end
