"""
# Description
ComponentPool, this is a pool storing all DesignConfig objects, for now it supports:
1. find certain config objects by the given config name
2. register a config with specified name.
"""
class ComponentPool

	attr :pool; # format: pool[name] = object.

	def initialize ##{{{
		@pool={};
	end ##}}}
public
	## place public methods here

	## API: find(name), return nil if not found, else return the object that
	# matches the same name.
	def find(name) ##{{{
		name=name.to_s;
		return @pool[name] if @pool.has_key?(name);
		return nil;
	end ##}}}

	## API: register(o), register the given design component object into pool
	def register(o) ##{{{
		name = o.name.to_s;
		$mp.warning("component registered previously, will overwrite it.") if @pool.has_key?(name);
		@pool[name] = o;
	end ##}}}
private
	## place private methods here
end