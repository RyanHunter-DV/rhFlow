class DesignView < IpxactBase

	"""
	Description,
	"""

	attr :comps;

	attr_accessor :nodes;
	attr_accessor :name;

	def initialize(n,p=nil) ##{{{
		# format: @comps['instname']=componentObject
		@comps={};
		# format: @nodes['location']=Proc
		@nodes={};
		@name = n;
		clones(p) if p;
		#TODO
	end ##}}}

public

	## findInstance(iname), find the instanced component by the given inst name
	def findInstance(iname); ##{{{
		iname = iname.to_s;
		return @comps[iname] if @comps.has_key?(iname);
		return nil;
	end ##}}}

	"""
	instances, return the instances hash for all instantiated components
	"""
	def instances ##{{{
		return @comps;
		#puts "#{__FILE__}:(instances) not ready yet."
	end ##}}}

	## instance, the instance command will instantiate certain components into the DesignView object.
	## So the Design object will not contain any component directly, the view will include those
	## components instead.
	# name->component type name
	# opts:
	# :as => :instname
	def instance(name,opts={}) ##{{{
		name = name.to_s;
		instname = name;
		instname = opts[:as].to_s if opts.has_key?(:as);
		comp = Rsim.find(:Component,name);
		raise UserException.new("component(#{name} not declared") unless comp;
		@comps[instname] = comp;
	end ##}}}

	## API: elaborate, to elaborate component instances in this view.
	def elaborate ##{{{
		@nodes.each_pair do |loc,b|
			#TODO, can enhance following codes.
			begin
				self.instance_eval &b;
			rescue => e
				msg = "Error detected in elaborate\n";
				msg+= "node location: #{loc}\n";
				msg+= "message: ";
				Rsim.mp.error("#{msg}#{e.message}");
				return Rsim::FAILED;
			end
		end
	end ##}}}

	def addBlock(b) ##{{{
		loc = b.source_location;
		@nodes[loc] = b;
	end ##}}}

private

	# clone all user blocks from parent's block, so that while elaborating
	# this view will also elaborate the cloned blocks;
	def clones(p) ##{{{
		p.nodes.each_pair do |loc,b|;
			@nodes[loc] = b;
		end
	end ##}}}

end
