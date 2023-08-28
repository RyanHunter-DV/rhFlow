class Rhload
	attr :visible;
	attr_accessor :nodes;
public
	def initialize(opts={}) ##{{{
		@nodes=[];
		Rsim.mp.debug("getting opts(#{opts})");
		addNodes(opts[:node]) if opts.has_key?(:node);
		setupVisible(opts[:visible]);
	end ##}}}
	def run() ##{{{
		Rsim.mp.debug("calling run of rhload");
		nodesEmpty() if @nodes.empty?;
		@nodes.each do |node|
			# file will be loaded like require command, so it's global scope
			if rhload(node) == Rsim::FAILED
				raise StepException.new(:rhload,Rsim::FAILED);
			end
		end
	end ##}}}

private

	def nodesEmpty() ##{{{
		Rsim.mp.error('no node files to be loaded');
		raise StepException.new(:rhload,Rsim::FAILED);
	end ##}}}
	def setupVisible(v=nil) ##{{{
		@visible = true;
		@visible = v if v;
	end ##}}}
	def addNodes(nodes) ##{{{
		Rsim.mp.debug("current @nodes type(#{@nodes.class})");
		@nodes = [] if @nodes==nil;
		Rsim.mp.debug("current @nodes type(#{@nodes.class})");
		if nodes.is_a?(Array)
			@nodes.append(*nodes);
		else
			@nodes << nodes;
		end
		Rsim.mp.debug("current @nodes(#{@nodes})");
		return;
	end ##}}}
end
