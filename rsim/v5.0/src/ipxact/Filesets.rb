class Filesets

	attr_accessor :source;

	# format
	# incdir[:rtl] -> []
	# incdir[:tb]  -> []
	attr_accessor :incdir;
	
	# raw files that is part of source file but not in filelist.
	attr_accessor :raw;

	#attr :shell; #TODO

	attr :type;
	def initialize(t) ##{{{
		initTypeByComponentType(t);
		@source={};@incdir={};
		@raw={};
	end ##}}}
public
	## place public methods here
	## API: addfiles(r,p,opts={}), add files from component caller, to process the pattern and add
	# all searched files into attrs, the @sources only allowed the opts[:filelist]=true.
	def addfiles(r,p,opts={}) ##{{{
		found = Shell.search(r,p);
		once = false;
		found.each do |f|
			if opts[:filelist]==true
				if once==false
					addIncdir(r);once=true;
				end
				@source << f;
			else
				@raw << f;
			end
		end
		#TODO
	end ##}}}
private
	## place private methods here
	## API: addIncdir(p), add given path into incdir if current incdir not has this path
	# the given p must absolute path.
	def addIncdir(p) ##{{{
		@incdir<<p unless @incdir.include?(p);
	end ##}}}

	def initTypeByComponentType(ct) ##{{{
		case (ct)
		when :hdl
			@type = :rtl;
		else
			@type = ct;
		end
	end ##}}}
end
