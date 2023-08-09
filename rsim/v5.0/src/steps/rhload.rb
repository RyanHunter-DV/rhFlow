require 'ipxact/MetaData'
require 'ipxact/Component'
require 'ipxact/Design'
require 'ipxact/DesignConfig'
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
	def rhload fname,visible=false ##{{{
	
	    ## if visible in arg is false, then set by Rhload's visible config
	    visible = @visible if visible==false;
	
		unless (/\.rh/=~fname or /\.rb/=~fname)
			fname += '.rh';
		end
	
		stacks = (caller(1)[0]).split(':');
		if stacks==nil
			Rsim.mp.error("cannot get caller, no load will execute");
			return Rsim::FAILED;
		end
		path = File.dirname(File.absolute_path(stacks[0]));
		## checking if the caller give an relative path
		## load by relative path first
		f = File.join(path,fname);
		if File.exists?(f)
			## puts "DEBUG, load: #{f}";
			load f;
			Rsim.mp.info("file #{File.absolute_path(f)} processed",visible);
			return Rsim::SUCCESS;
		end
	
		## checking if the caller gives an abasolute path
		## load directly with the given path+name
		if File.exists?(fname)
			## load directly
			## dir = File.dirname(File.absolute_path(fname));
			## $LOAD_PATH << dir unless $LOAD_PATH.include?(dir);
			## puts "DEBUG, load: #{File.absolute_path(fname)}";
			load fname;
			Rsim.mp.info("file #{File.absolute_path(fname)} processed",visible);
			return Rsim::SUCCESS;
		end
	
	
		## if not exists by the path, searching with LOAD_PATH
		## load from RUBYLIB
		$LOAD_PATH.each do |p|
			full = File.join(p,fname);
			if File.exists?(full)
				## push dir to LOAD_PATH
				## dir = File.dirname(File.absolute_path(full));
				## $LOAD_PATH << dir unless $LOAD_PATH.include?(dir);
				## puts "DEBUG, load: #{full}";
				load full;
				Rsim.mp.info("file #{File.absolute_path(full)} processed",visible);
				return Rsim::SUCCESS;
			end
		end


		Rsim.mp.error("file not exists in search path(#{fname})",:pos=>caller(0)[0]);
		return Rsim::FAILED;
	
	end ##}}}
end
