class PoolBase

	attr :pool;
	def initialize ##{{{
		# format: @pool['name'] = object.
		@pool={};
	end ##}}}

public
	## place public methods here

	## API: find(n), accoding to given name, find current registered object 
	# if not exists, then return nil.
	def find(n) ##{{{
		n=n.to_s;
		return @pool[n] if @pool.has_key?(n);
		return nil;
	end ##}}}

	## API: register(o), register current object into pool, index by name
	# if already registered, then the previous one will be overwritten.
	def register(o) ##{{{
		@pool[o.name] = o;
	end ##}}}

private
	## place private methods here

end