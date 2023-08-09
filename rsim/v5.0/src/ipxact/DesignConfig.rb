class DesignConfig < MetaData
	attr_accessor :name;

	attr :simulator;
	attr :design;
	attr :marks;
	def initialize ##{{{
		#TODO
		@simulator = nil;
		@design=nil;
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


	## API: design, method to return the instance var: @design, which is an object
	## of ipxact design
	def design ##{{{
		return @design;
	end ##}}}

	## opt, the option command, used by node block, to specify certain object's options
	## for example: opt compiler, '-A xxx', the compile is a local method which will return an object
	## of the named tool, and then call the option.add API of that tool, so that the option can be added
	def opt(tool,*opts) ##{{{
		# TODO, psudo codes, following is sketch steps may used later.
		if tool==nil
			msg = "tool specified by opt command not exists in config(#{@name})\n";
			msg +="-- node position: #{self.nodeLocation}";
			raise NodeException.new(msg);
		end
		opts.each do |o|
			tool.option.add o;
		end
	end ##}}}


	## simulator, the command to specify a simulator tool. by which will dynamically load the simulator wrapper, which
	## contains a lot of APIs to translate rsim based options into certain simulator options.
	## support format: :vcs, :xrun, :questa, current only supports :xrun, since we have only :xrun tool now.
	## when input arg is nil, which users didn't enter any arg, then this command will return the specified simulator.
	def simulator(toolmark=nil) ##{{{
		#TODO
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
		#TODO
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
def config(name,opts={}) ##{{{
	#TODO
	#TODO, need support: opts[:clone]
end ##}}}
