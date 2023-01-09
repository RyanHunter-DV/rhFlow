rhload 'lib/cmdshell.rb'
module ProjectLoader

	@debug = nil;

	def self.debug= d;@debug=d; end
	def self.findentries d ##{{{
		"""
		input d is the root dir of project
		"""
		entries = [];
		@debug.print("findentry for: #{d}");
		entries = Shell.find(d,'root.rh','-maxdepth 2');
		return entries;
	end ##}}}
	def self.loadimports d ##{{{
		entries = findentries(d);
		entries.each do |e|
			r = File.dirname(e);
			ProjectLoader.loadimports("#{r}/imports");
			ProjectLoader.loadlocal(e);
		end
	end ##}}}

	def self.loadlocal e ##{{{
		"""
		e: the entry */root.rh
		"""
		Rhload.visible= true;rhload(e);Rhload.visible= false;
		@debug.print("all file loaded for #{e}");
		@debug.print("parse contexts");
		Context.parse;
		## debug
		ComponentPool.pool.each_pair do |n,o|
			@debug.print("global component(#{n}): #{o.class}");
		end
		ConfigPool.pool.each_pair do |n,o|
			@debug.print("global config(#{n}): #{o.class}");
		end
		TestPool.pool.each_pair do |n,o|
			@debug.print("global test(#{n}): #{o.class}");
		end
	end ##}}}
end
