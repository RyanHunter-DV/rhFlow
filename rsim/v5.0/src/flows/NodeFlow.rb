"""
# Object description:
This flow will load all required files from the entry node: root.rh, which specified by user.
The flow object will be loaded dynamically by the runner (DynamicLoader), and then call the run api.
## Loading nodes
run api will use rhload to load the entry file from user specification.
User nodes will call different global commands such as component, config or design to build different
IP-XACT database.
## Elaboration
Elaborate of a meta data is actually to run user defined blocks after all nodes loaded into the database.
Elaboration will first eval the configs, this specially to set parameter overrides for components before
they're being elaborated.
Elaboration is part of the nodeflow that will be automatically called after rhload.
"""

require 'exceptions/UserException';

require 'ipxact/IpxactBase'
require 'ipxact/Component'
require 'ipxact/Design'
require 'ipxact/DesignConfig'

require 'libs/rhload' # load global rhload api

class NodeFlow < StepBase

	def initialize(opts={}) ##{{{
		ui = opts[:ui]; @entry = opts[:node][0]; # currently supports only one node file
		super('node',nil,ui);
	end ##}}}

	def run() ##{{{
#TODO, require UiException, which process all user input options issues.
		raise UserException.new("required root entry not specified") unless @entry;
#TODO, require global var: $mp, which defined at core, for global MessagePrinter
		Rsim.mp.debug("loading entry node:(#{@entry})");
		rhload @entry;
		Rsim.elaborate;
	end ##}}}

public

private

end