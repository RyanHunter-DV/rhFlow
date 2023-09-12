"""
The base ipxact object type, the IpxactBase, all ipxact data model inherits from this
class.
"""
class IpxactBase
	attr_accessor :vlnv;


	# A hash used to store dirs, available pairs:
	# [:published] -> the published dir of this component, out/components/<CompName>
	# [:source] -> the source node dir of this component, for different blocks, the source is different.
	# TODO, which will create unique id for different nodes for this component.
	attr_accessor :dirs;

	attr :nodes;
	attr :nodeloc;
	def initialize(name) ##{{{
		@vlnv = name.to_s;
		## format is: nodes[block.location] = &block;
		@nodes={};
	end ##}}}

public
	## API: push(loc,b), inject a new block with the location.
	def push(locs,b) ##{{{
		file = File.absolute_path(locs[0]);
		loc = "#{file},#{locs[1]}"; # <file>,<line>
		Rsim.mp.debug("pushing nodes, loc(#{loc})");
		@nodes[loc] = b;
	end ##}}}

	## API: evalUserNodes(o), to eval the user nodes by the given object
	def evalUserNodes(t,o) ##{{{
		@nodes.each_pair do |loc,b|
			begin
				@nodeloc = loc;
				o.instance_eval &b;
			rescue => e
				msg = "Error detected in #{t}.elaborate\n";
				msg+= "node location: #{loc}\n";
				msg+= "message: ";
				Rsim.mp.error("#{msg}#{e.message}");
				caller(0).each do |stack|
					Rsim.mp.error(stack);
				end
				return Rsim::FAILED;
			end
		end
		return Rsim::SUCCESS;
	end ##}}}

	## API: name(n=''), if given n is not '', then set the vlnv, else return it
	def name(n='') ##{{{
		return @vlnv if n=='';
		@vlnv = n;
	end ##}}}

private


	## API: currentNodeLocation(fmt), according to given format, return current node location
	# fmt = :file, return file
	# fmt = :path, return path where this node exists
	# fmt = :full, return <file,line> location.
	def currentNodeLocation(fmt=:full) ##{{{
		case(fmt)
		when :file
			return @nodeloc.split(',')[0];
		when :path
			f = @nodeloc.split(',')[0];
			return File.dirname(f);
		when :full
			return @nodeloc;
		else
			raise "not supported format(#{fmt})";
		end
	end ##}}}

end
