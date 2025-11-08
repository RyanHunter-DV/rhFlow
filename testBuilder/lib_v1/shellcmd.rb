# TODO, this is ShellCmd from work db
# - add builddir
class ShellCmd

	attr :debug;
	def initialize(d) ##{{{
		@debug = d;
	end ##}}}

	def builddir(p) ##{{{
		Dir.mkdir(p) unless Dir.exist?(p);
	end ##}}}

end