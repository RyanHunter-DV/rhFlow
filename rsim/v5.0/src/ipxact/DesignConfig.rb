require 'exceptions/UserException'
class DesignConfig < IpxactBase
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

	# format
	# dirs[:out] -> out path for this config.
	# dirs[:fulllist] -> full filelist name + path
	attr_accessor :dirs;

	attr_accessor :nodes;

	attr :simulator;
	attr :design;attr :view;
	attr :marks;
	attr :needs; # local needs specified by user nodes

	def initialize(n) ##{{{
		super(n);
		@simulator = nil;
		@needs={};
		@design=nil;@view=nil;
		@marks = {
			:xrun   => 'Xcelium',
			:vcs    => 'Vcs',
			:questa => 'Questasim'
		}
		setupDirs;
	end ##}}}

public


	## param(o,opts), overrides the target o's params according to given opts
	def param(o,opts); ##{{{
		o.send(:param,opts,self);
		#puts "#{__FILE__}:(param(o,opts)) is not ready yet."
	end ##}}}


	## view(name), user node command to specify which to to be used in this config.
	# using examples:
	# - view(:viewname)
	# this will be recorded into @viewname, which will be used in building flow
	def view(name) ##{{{
		#@design.setview(name); # set target view of this config
		raise UserException.new("view(#{name}) not declared in design") unless @design.views.has_key?(name);
		@view = @design.views[name] ;
		@design.setupView(name);
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
			msg = "tool specified by opt command not exists in config(#{@vlnv})\n";
			msg +="-- node position: #{currentNodeLocation}";
			raise UserException.new(msg);
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
		toolmark = toolmark.to_sym;
		unless @marks.has_key?(toolmark)
			msg = "invalid simulator mark(#{toolmark}), please use following types:\n";
			@marks.each_key do |k|
				msg += "- #{k}\n";
			end
			Rsim.mp.error(msg);
			raise UserException.new('error in using simulator');
		end
		tool = @marks[toolmark].to_s;
		Rsim.mp.debug("load and creating simulator: #{tool}");
		opts={:filelist=>@dirs[:fulllist]};
		require "simulator/#{tool}";
		@simulator = eval %Q|#{tool}.new(opts)|;
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


	## nestedComponents, api to return all required component of this config, if this api
	# is called first time, then will analyze and load the nested component relations, else
	# return the analyzed nestComponents.
	def nestedComponents; ##{{{
		#allocateNestedComponents if @nests.empty?;
		return @needs;
	end ##}}}

	## need(name), need a component to build this config
	def need(instname); ##{{{
#TODO, exception mechanism required, raise UserException.new("a view must specified before calling need") if @view==nil;
		c= @view.findInstance(instname);
		@needs[instname] = c unless c==nil;
	end ##}}}

	"""
	addBlock(b), to add code block into nodes through push api
	"""
	def addBlock(b) ##{{{
		push(b.source_location,b);
		#puts "#{__FILE__}:(addBlock(b)) not ready yet."
	end ##}}}

private

	## extra options needed if @simulator is nil but called by user, shall raise exceptions.
	def getSimulator ##{{{
		return @simulator if @simulator!=nil;
		msg = "calling simulator before specified in config(#{@vlnv})\n";
		msg+= "setting a simulator shall placed before getting it\n";
		msg+= "-- node position: #{currentNodeLocation}";
		raise UserException.new(msg);
	end ##}}}

	## setupDirs, setup the out path of this config and full filelist name
	def setupDirs; ##{{{
		@dirs={};
		@dirs[:out] = File.join(Rsim.dirs[:configs],@vlnv);
		@dirs[:fulllist] = File.join(@dirs[:out],'full.filelist');
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
	Rsim.register(c);
end ##}}}
