rhload 'lib/context.rb'
class Imports;

	attr :topname;
	attr_accessor :contexts;

	def initialize top ##{{{
		@topname = top.to_s;
		@contexts= [];
	end ##}}}


	def __findRoots__ d ##{{{
	end ##}}}

	def __linkContext__ ##{{{
		begin
			raise NoContextException if Context.current.name==@topname;
			@contexts << Context.current;
		rescue NoContextException => e
			e.process("no available context found");
		end
	end ##}}}


	def loadall d ##{{{
		"""
		to read all */root.rh within the given d (dir). Each */root.rh will define
		a context, and the component map. like:
		context :uvm do
			component :standard
		end
		required 'uvm.standard'
		"""
		roots = __findRoots__(d);
		roots.each do |r|
			Rhload.visible= true;rhload(r);Rhload.visible= false;
			__linkContext__;
			Context.current.finalize;
		end
	end ##}}}
end
