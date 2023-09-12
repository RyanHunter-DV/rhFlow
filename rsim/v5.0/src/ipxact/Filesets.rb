require 'libs/cmdshell'
class Filesets

	# one fileset can only support one component type.
	attr_accessor :incdir;
	attr_accessor :source;

	# raw files that is part of source file but not in filelist.
	attr_accessor :raw;

	attr :type;
	def initialize(t) ##{{{
		initTypeByComponentType(t);
		@source=[];@incdir=[];
		@raw={};
	end ##}}}
public
	## place public methods here
	## API: addfiles(r,p,opts={}), add files from component caller, to process the pattern and add
	# all searched files into attrs, the @sources only allowed the opts[:filelist]=true.
	def addfiles(r,p,opts={}) ##{{{
		found = Shell.search(r,p);
		once = false;
		Rsim.mp.debug("searching path(#{r}), patter(#{p})");
		Rsim.mp.debug("found files: (#{found})");
		#puts RUBY_PLATFORM
		#if Shell.os==:windows
		#	found=['D:/panel/Quest/rhFlow-main/rsim/v5.0/test/ipxact/test.v'];
		#	Rsim.mp.debug("in window system, add temp file #{found}");
		#end
		raise UserException.new("no file found by the given fileset pattern(#{p})") if found.empty?;
		found.each do |f|
			if opts[:filelist]
				unless once
					addIncdir(r);once=true;
				end
				@source << f;
			else
				@raw << f;
			end
		end
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
