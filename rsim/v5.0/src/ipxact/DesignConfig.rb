class DesignConfig < MetaData
	"""
	Description, configs for a certain design object in Rsim, since for one flow running, the design is unique,
	so it will be linked only once after elaborate
	Features:
	....
	public APIs:
	- design, return the design object in Rsim, which is linked durng elaborate
	- elaborate, called by metadata, to eval user nodes.
	- opt, called by user nodes, to specify options for a certain object, supports: eda's option, generator's option.
	In design config, the specified tool is a generic object called tool, which shall all have the option object, then
	in here can only call tool.option.add ...
	- simulator, if user specified the tool marker, then will build a new simulator object, if user not specified anything,
	then will return the pre-created simulator object.
	"""


	attr_accessor :name;

	# format
	# dirs[:out] -> out path for this config.
	# dirs[:fulllist] -> full filelist name + path
	attr_accessor :dirs;

	attr_accessor :nodes;

	attr :simulator;
	attr :design;attr :viewname;
	attr :marks;

	def initialize(n) ##{{{
		@name = n;
		@simulator = nil;
		@design=nil;@viewname='';
		@marks = {
			:xrun   => 'Xcelium',
			:vcs    => 'Vcs',
			:questa => 'Questasim'
		}
	end ##}}}

public
	## <DefinedDesign>, this is automatically built when a design is declared in a node file
	## the corresponding method named as the design name will be declared within the DesignConfig
	## object.

## view(name), user node command to specify which to to be used in this config.
# using examples:
# - view(:viewname)
# this will be recorded into @viewname, which will be used in building flow
	def view(name) ##{{{
		@viewname=name;
	end ##}}}

	## API: design, method to return the instance var: @design, which is an object
	## of ipxact design
	def design ##{{{
		return @design;
	end ##}}}

	## opt, the option command, used by node block, to specify certain object's options
	## for example: opt compiler, '-A xxx', the compile is a local method which will return an object
	## of the named tool, and then call the option.add API of that tool, so that the option can be added
	## calling example:
	## - opt design.simulator.compile 'xxx','xxx'...
	## - opt design.simulator.elab 'xxx','xxx'...
	## - opt design.simulator.run 'xxx','xxx'...
	## - opt design.compA.generator 'xxx','xxx'...
	##
	def opt(tool,*opts) ##{{{
		if tool==nil
			msg = "tool specified by opt command not exists in config(#{@name})\n";
			msg +="-- node position: #{self.nodeLocation}";
			raise NodeException.new(msg);
		end
		opts.each do |o|
#TODO, require the tool has option object, which comes from the same ToolOption, and require add api
			tool.option.add o;
		end
	end ##}}}


	## simulator, the command to specify a simulator tool. by which will dynamically load the simulator wrapper, which
	## contains a lot of APIs to translate rsim based options into certain simulator options.
	## support format: :vcs, :xrun, :questa, current only supports :xrun, since we have only :xrun tool now.
	## when input arg is nil, which users didn't enter any arg, then this command will return the specified simulator.
	def simulator(toolmark=nil) ##{{{
		return getSimulator if toolmark==nil;
		require "simulator/#{@marks[toolmark]}";
		@simulator = eval %Q|#{tool.capitalize}.new()|;
	end ##}}}


	## public apis called by other rsim objects.

	## API: elaborate, to elaborate the loaded user nodes from config
	## down to the base component.
	def elaborate ##{{{
		@design = Rsim.design;
		result = evalUserNodes(:config,self);
		return result;
	end ##}}}


	# to clone the parent name config's blocks so that it can be evaluated while the elaborate called
	def clones(pname) ##{{{
		p = Rsim.find(:config,pname);
		return if p==nil; ## if p not exists, return
		p.nodes.each_pair do |loc,b|
			@nodes[loc] = b;
		end
	end ##}}}

private


	## extra options needed if @simulator is nil but called by user, shall raise exceptions.
	def getSimulator ##{{{
		return @simulator if @simulator!=nil;
		msg = "calling simulator before specified in config(#{@name})\n";
		msg+= "setting a simulator shall placed before getting it\n";
		msg+= "-- node position: #{self.nodeLocation}";
		raise NodeException.new(msg);
		return nil;
	end ##}}}
	
end

## the global config command in user nodes, shall support
## :clone => :OtherConfig option.
def config(name,opts={},&block) ##{{{
	c=Rsim.find(:config,name);
	c=DesignConfig.new(name) if c==nil;
	c.addBlock(block);
	opts.each do |o,v|
		message = o.to_sym;
		c.send(message,v);
	end
end ##}}}
