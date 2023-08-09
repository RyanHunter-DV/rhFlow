"""
The base ipxact object type, the MetaData, all ipxact data model inherits from this
class.
"""
class MetaData
	attr_accessor :vlnv;

	attr :nodes;
	def initialize(name) ##{{{
		@vlnv = name;
		## format is: nodes[block.location] = &block;
		@nodes={};
	end ##}}}

public
	## API: push(loc,b), inject a new block with the location.
	def push(locs,b) ##{{{
		file = File.absolute_path(locs[0]);
		loc = "#{file},#{locs[1]}"; # <file>,<line>
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

	attr :nodeloc;

	## API: currentNodeLocation(fmt), according to given format, return current node location
	# fmt = :file, return file
	# fmt = :path, return path where this node exists
	# fmt = :full, return <file,line> location.
	def currentNodeLocation(fmt) ##{{{
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
